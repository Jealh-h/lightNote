import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:lightnote/components/image_comp.dart';
import 'dart:ui' as UI show ImageByteFormat, Image;

import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';

class WriteNote extends StatefulWidget {
  WriteNote(
      {Key? key,
      required this.height,
      required this.notebookInfo,
      this.noteInfo})
      : super(key: key);
  double height;
  Map notebookInfo;
  Map? noteInfo;

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  Offset pos = Offset(0, 0);
  double _left = 0;
  double _top = 0;
  int drawCount = 0;
  late FocusNode _focusNode;
  List<Offset> currentPath = [];
  Map userInfo = {};
  ScrollController sc = ScrollController();

  /// 标记签名画板的Key，用于截图
  late GlobalKey _globalKey;
  List<Uint8List> screenHot = [];
  String _title = '测试';

  String netImageUrl = '';
  UI.Image? noteImage;

  // 绘制的路径
  List<List<Offset>> path = [];
  @override
  void initState() {
    // TODO: implement initState
    _globalKey = GlobalKey();
    getUserInfo().then((value) => {
          setState(() {
            userInfo = value;
            if (widget.noteInfo != null) {
              loadImage(widget.noteInfo!["imageUrl"])
                  .then((value) => noteImage = value);
            }
          })
        });
  }

  Future<UI.Image> loadImage(var path) async {
    ImageStream stream;

    stream = NetworkImage(path).resolve(ImageConfiguration.empty);
    Completer<UI.Image> completer = Completer<UI.Image>();
    void listener(ImageInfo frame, bool synchronousCall) {
      final UI.Image image = frame.image;
      completer.complete(image);
      stream.removeListener(ImageStreamListener(listener));
    }

    stream.addListener(ImageStreamListener(listener));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                _saveImage();
              },
              child: Text("保存"))
        ],
      ),
      body: Stack(
        children: [
          // 画板
          RepaintBoundary(
            key: _globalKey,
            child: Stack(alignment: AlignmentDirectional.topCenter, children: [
              Padding(
                padding: EdgeInsets.all(0),
                child: GestureDetector(
                  onPanDown: (DragDownDetails e) {
                    path.add([e.localPosition]);
                  },
                  //手指滑动时会触发此回调
                  onPanUpdate: (DragUpdateDetails e) {
                    //用户手指滑动时
                    setState(() {
                      path[path.length - 1].add(e.localPosition);
                    });
                  },
                  onPanEnd: (DragEndDetails e) {
                    //打印滑动结束时在x、y轴上的速度
                    currentPath = [];
                  },
                  child: Container(
                    color: Colors.transparent,
                    width: double.infinity,
                    height: widget.height,
                    child: CustomPaint(
                      isComplex: true,
                      willChange: true,
                      foregroundPainter:
                          LinerPainter(path, noteInfo: noteImage),
                    ),
                  ),
                ),
              ),
              ImageContainer()
            ]),
          ),
          // 工具层
          _buildErase(),
          Positioned(
            left: 20,
            bottom: 20,
            child: TextButton(
              child: Text("添加"),
              onPressed: () {
                // _capturePng()
                _saveImage();
                // setState(() {
                //   widget.height += 200;
                //   print(MediaQuery.of(context).size.height);
                //   print(widget.height);
                // });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErase() {
    return // 清空屏幕
        Positioned(
      right: 20,
      bottom: 20,
      child: GestureDetector(
        onTap: () {
          setState(() {
            path = [];
          });
        },
        child: Container(
          width: 48,
          height: 48,
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade200)],
            borderRadius: BorderRadius.circular(32),
          ),
          child: ClipOval(
            child: Image.asset(
              "assets/icons/erase.png",
            ),
          ),
        ),
      ),
    );
  }

  /// 添加点，注意不要超过Widget范围
  _addPoint(DragUpdateDetails details) {
    // RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
    RenderBox referenceBox = context.findRenderObject() as RenderBox;
    Offset localPosition = referenceBox.globalToLocal(details.localPosition);
    double maxW = referenceBox.size.width;
    double maxH = referenceBox.size.height;
    // 校验范围
    if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
    if (localPosition.dx > maxW || localPosition.dy > maxH) return;
    setState(() {
      currentPath.add(localPosition);
      path.add(currentPath);
    });
  }

  // widget截图
  //
  // 上传笔记到服务器
  void _saveImage() async {
    try {
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      var image = await boundary.toImage(
          pixelRatio: MediaQuery.of(context).devicePixelRatio);
      ByteData byteData =
          await image.toByteData(format: UI.ImageByteFormat.png) as ByteData;
      Uint8List pageBytes = byteData.buffer.asUint8List(); //图片data
      // screenHot[0] = pageBytes;
      var result = await dioUploadFileByByte(pageBytes as List<int>, {
        ...userInfo,
        ...widget.notebookInfo,
        "title": _title,
      });
      print("save-result:$result");
      if (result["status"] == 'success') {
        setState(() {
          netImageUrl = result["data"];
        });
        EasyLoading.showSuccess("保存成功");
      } else {
        EasyLoading.showInfo(result["data"]);
      }
    } catch (e) {
      //保存失败
      print(e);
    }
  }
}

class LinerPainter extends CustomPainter {
  LinerPainter(this.path, {this.noteInfo});
  final List<List<Offset>> path;
  UI.Image? noteInfo;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = Colors.black;
    if (noteInfo != null) {
      canvas.drawImage(noteInfo!, Offset(0, 0), paint);
    }
    path.forEach((list) {
      Path _path = Path();
      for (int i = 0; i < list.length; i++) {
        if (i == 0) {
          _path.moveTo(list[i].dx, list[i].dy);
        } else {
          _path.lineTo(list[i].dx, list[i].dy);
        }
      }
      canvas.drawPath(_path, paint);
    });
    // for (int i = 0; i < path[path.length].length; i++) {
    //   canvas.drawCircle(path[path.length][i], 2, paint);
    // }
    // canvas.drawLine(
    //     Offset(0, 0), Offset(size.width * 5 / 6, size.height * 1 / 2), paint);
  }

  @override
  bool shouldRepaint(LinerPainter oldDelegate) {
    // throw UnimplementedError();
    // return oldDelegate.path != path;
    return true;
  }
}
