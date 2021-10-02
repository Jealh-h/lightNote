import 'dart:async';
import 'dart:typed_data';
import 'dart:ui';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lightnote/components/image_comp.dart';
import 'package:lightnote/components/text_comp.dart';
import 'package:lightnote/model/emailUrl.dart';
import 'package:provider/provider.dart';
import 'dart:ui' as UI show ImageByteFormat, Image;
import 'package:lightnote/utils/http.dart';
import 'package:lightnote/utils/utils.dart';

class WriteNote extends StatefulWidget {
  WriteNote(
      {Key? key,
      required this.height,
      required this.notebookInfo,
      required this.opr,
      this.noteInfo})
      : super(key: key);
  double height;
  Map notebookInfo;
  Map? noteInfo;
  // 判断是增加还是删除
  String opr;
  List colorList = [
    Color(0xffff4d4f),
    Color(0xffff7a45),
    Color(0xffffa940),
    Color(0xffffc53d),
    Color(0xffffec3d),
    Color(0xffa0d911),
    Color(0xff52c41a),
    Color(0xff1890ff),
    Color(0xff2f54eb),
    Color(0xff531dab),
    Color(0xffeb2f96),
    Color(0xff000000),
  ];

  @override
  _WriteNoteState createState() => _WriteNoteState();
}

class _WriteNoteState extends State<WriteNote> {
  TextEditingController _textController = new TextEditingController();

  final ImagePicker _picker = ImagePicker();
  Offset pos = Offset(0, 0);

  Map userInfo = {};
  ScrollController sc = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  /// 标记签名画板的Key，用于截图
  late GlobalKey _globalKey;
  List<Uint8List> screenHot = [];
  TextEditingController _title = new TextEditingController();

  // 网络图片路径
  String netImageUrl = '';
  // 笔记图片资源
  UI.Image? noteImage;

  Map painterConfig = {"width": 2.0, "color": Colors.black, "type": "line"};
  Map textConfig = {"color": Colors.black, "size": 14};

  // 绘制的路径
  List<Map<String, dynamic>> path = [];

  // 当前绘制的步数，用于redo与undo  drawstep = richArr.length-1;
  int drawStep = 0;

  //  保存绘制路径的种类，图片文字为1，canvas为0
  List stepArr = [];
  // 保存的历史状态
  Queue stepRedo = new Queue();

  // canvas 图形队列
  Queue redoQueue = new Queue();

  // 图片文字widget数组
  List<Widget> richArr = [];
  // 图片文字队列
  Queue richQueue = new Queue();

  // 控制线条与方框的active样式
  List activeArr = ["common", "common"];

  @override
  void initState() {
    _globalKey = GlobalKey();
    getUserInfo().then((value) => {
          setState(() {
            userInfo = value;
            if (widget.noteInfo != null) {
              loadImage(widget.noteInfo!["imageUrl"]).then((value) {
                noteImage = value;
              });
            }
          })
        });
  }

// 加载网络图片
  Future<UI.Image> loadImage(var path) async {
    ImageStream stream;
    var size = MediaQuery.of(context).size;
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
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          TextButton(
            onPressed: () {
              _saveImage();
            },
            child: Text("保存"),
          ),
          IconButton(
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
              icon: Icon(Icons.menu))
        ],
      ),
      endDrawer: Drawer(
        child: _buildToolDrawer(),
      ),
      body: Stack(
        children: [
          // 画板
          RepaintBoundary(
            key: _globalKey,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.all(0),
                  child: GestureDetector(
                    onPanDown: (DragDownDetails e) {
                      // path.add([e.localPosition]);
                      path.add({
                        "width": painterConfig["width"],
                        "color": painterConfig["color"],
                        "data": [e.localPosition],
                        "type": painterConfig["type"]
                      });
                    },
                    //手指滑动时会触发此回调
                    onPanUpdate: (DragUpdateDetails e) {
                      //用户手指滑动时
                      setState(() {
                        // path[path.length - 1].add(e.localPosition);

                        // 画图形
                        if ((painterConfig["type"] == "rect" ||
                                painterConfig["type"] == "straight") &&
                            path[path.length - 1]["data"].length == 2) {
                          path[path.length - 1]["data"][1] = e.localPosition;
                        } else {
                          path[path.length - 1]["data"].add(e.localPosition);
                        }
                      });
                    },
                    onPanEnd: (DragEndDetails e) {
                      stepArr.add(0);
                      drawStep++;
                    },
                    child: Container(
                      color: Colors.transparent,
                      width: size.width,
                      height: size.height - 80,
                      child: CustomPaint(
                        isComplex: true,
                        willChange: true,
                        painter: LinerPainter(path, painterConfig,
                            noteInfo: noteImage),
                      ),
                    ),
                  ),
                ),
                // ...stepArr.map((e) => e)
                ...richArr.map((e) => e),
              ],
            ),
          ),
          // 工具层
          _buildErase(),
          Positioned(
            left: 20,
            bottom: 20,
            // undo && redo
            child: Row(
              children: [
                // undo
                _buildToolButton(() {
                  // 放入redo数组
                  // undo数组减一
                  setState(() {
                    if (stepArr.length - 1 >= 0) {
                      if (stepArr.last == 0) // canvas
                      {
                        redoQueue.add(path.last);
                        path.removeLast();
                        stepRedo.add(stepArr.last);
                        stepArr.removeLast();
                      } else {
                        // 图片文字
                        richQueue.add(richArr.last);
                        richArr.removeLast();
                        stepRedo.add(stepArr.last);
                        stepArr.removeLast();
                      }
                    } else {
                      EasyLoading.showInfo("不能再后退了");
                    }
                  });
                }, Icon(Icons.undo)),
                SizedBox(
                  width: 10,
                ),
                // redo
                _buildToolButton(
                  () {
                    setState(() {
                      if (stepRedo.length - 1 >= 0) {
                        if (stepRedo.last == 0) {
                          // canvas绘制的
                          path.add(redoQueue.last);
                          redoQueue.removeLast();
                          stepArr.add(stepRedo.last);
                          stepRedo.removeLast();
                        } else {
                          // 图片文字
                          richArr.add(richQueue.last);
                          richQueue.removeLast();
                          stepArr.add(stepRedo.last);
                          stepRedo.removeLast();
                        }
                      } else {
                        EasyLoading.showInfo("不能再前进了");
                      }
                    });
                  },
                  Icon(Icons.redo),
                ),
                SizedBox(
                  width: 30,
                ),
                // draw straight-line
                _buildToolButton(
                  () {
                    setState(() {
                      if (activeArr[0] == "active") {
                        activeArr = ["common", 'common'];
                        painterConfig["type"] = "line";
                      } else {
                        activeArr = ["active", "common"];
                        painterConfig["type"] = "straight";
                      }
                    });
                  },
                  Icon(
                    Icons.remove,
                    color:
                        activeArr[0] == 'active' ? Colors.amber : Colors.black,
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                // draw rect
                _buildToolButton(
                  () {
                    setState(() {
                      if (activeArr[1] == "active") {
                        activeArr = ["common", 'common'];
                        painterConfig["type"] = "line";
                      } else {
                        activeArr = ["common", "active"];
                        painterConfig["type"] = "rect";
                      }
                    });
                  },
                  Icon(
                    Icons.crop_3_2,
                    color:
                        activeArr[1] == 'active' ? Colors.amber : Colors.black,
                  ),
                )
              ],
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

  // 工具按钮
  Widget _buildToolButton(Function callback, Widget child) {
    return GestureDetector(
      onTap: () {
        callback();
      },
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)]),
        child: child,
      ),
    );
  }

  /// 添加点，注意不要超过Widget范围
  // _addPoint(DragUpdateDetails details) {
  //   // RenderBox referenceBox = _globalKey.currentContext.findRenderObject();
  //   RenderBox referenceBox = context.findRenderObject() as RenderBox;
  //   Offset localPosition = referenceBox.globalToLocal(details.localPosition);
  //   double maxW = referenceBox.size.width;
  //   double maxH = referenceBox.size.height;
  //   // 校验范围
  //   if (localPosition.dx <= 0 || localPosition.dy <= 0) return;
  //   if (localPosition.dx > maxW || localPosition.dy > maxH) return;
  // }

  // widget截图
  // 上传笔记到服务器
  void _saveImage() async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("标题"),
            content: TextField(
              controller: _title,
              decoration: InputDecoration(hintText: "请输入标题"),
            ),
            actions: [
              TextButton(
                  onPressed: () async {
                    if (_title.text == "") {
                      EasyLoading.showInfo("请输入标题");
                    } else {
                      try {
                        RenderRepaintBoundary boundary =
                            _globalKey.currentContext!.findRenderObject()
                                as RenderRepaintBoundary;
                        var image = await boundary.toImage(
                            pixelRatio: window.devicePixelRatio);
                        // var image = await boundary.toImage(pixelRatio: 1);
                        ByteData byteData = await image.toByteData(
                            format: UI.ImageByteFormat.png) as ByteData;
                        Uint8List pageBytes =
                            byteData.buffer.asUint8List(); //图片data

                        var param;
                        if (widget.noteInfo == null) {
                          param = {
                            ...userInfo,
                            ...widget.notebookInfo,
                            "opr": widget.opr,
                            "title": _title.text,
                          };
                        } else {
                          param = {
                            ...userInfo,
                            ...widget.notebookInfo,
                            ...widget.noteInfo!,
                            "opr": widget.opr,
                            "title": _title.text,
                          };
                        }

                        var result = await dioUploadFileByByte(
                            pageBytes as List<int>, {...param});
                        if (result["status"] == 'success') {
                          setState(() {
                            netImageUrl = result["data"];
                          });
                          EasyLoading.showSuccess("保存成功");
                          Navigator.pop(context);
                        } else {
                          EasyLoading.showInfo(result["data"]);
                        }
                      } catch (e) {
                        //保存失败
                        print(e);
                      }
                    }
                  },
                  child: Text("确认")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("取消"))
            ],
          );
        });
  }

  Widget _buildTipText(String text) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  // 构建调整绘制参数的Drawer
  Widget _buildToolDrawer() {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.8,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 50),
          child: Column(
            children: [
              _buildTipText("调整宽度"),
              Container(
                height: 130,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      height: painterConfig["width"],
                      decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    Slider(
                      min: 2,
                      max: 10,
                      value: painterConfig["width"],
                      onChanged: (value) {
                        setState(() {
                          painterConfig["width"] = value;
                        });
                      },
                    ),
                  ],
                ),
              ),
              _buildTipText("添加文字或图片"),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // 添加图片
                  _buildToolButton(() {
                    Navigator.pop(context);
                    showImgSelectModal(
                        context, selectImgByCamera, selectImgByGallery);
                  }, Icon(Icons.image)),
                  // 添加文字
                  _buildToolButton(() {
                    Navigator.pop(context);
                    showTextInput();
                  }, Icon(Icons.text_fields)),
                ],
              ),
              _buildTipText("更改画笔颜色"),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("当前颜色:"),
                  Container(
                    margin: EdgeInsets.only(left: 50),
                    height: 10,
                    width: 50,
                    color: painterConfig["color"],
                  ),
                ],
              ),
              Container(
                height: 300,
                child: GridView.count(
                  crossAxisCount: 5,
                  children: widget.colorList.map((e) {
                    return _buildColorItem(e);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 颜色组
  Widget _buildColorItem(Color c) {
    return GestureDetector(
      onTap: () {
        setState(() {
          painterConfig["color"] = c;
        });
      },
      child: Container(
        height: 32,
        width: 32,
        decoration: BoxDecoration(
            color: c,
            boxShadow: [BoxShadow(blurRadius: 5, color: Colors.grey.shade300)]),
      ),
    );
  }

  // 从相机获取图片
  void selectImgByCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      var imageBytes = await image.readAsBytes();
      setState(() {
        stepArr.add(1);
        drawStep++;
        richArr.add(ImageContainer(
          image: imageBytes,
        ));
      });
    } else {}
  }

  // 从图库获取图片
  void selectImgByGallery() async {
    var image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      var imageBytes = await image.readAsBytes();
      setState(() {
        richArr.add(ImageContainer(
          image: imageBytes,
        ));
      });
    } else {}
  }

  // 显示文本输入框
  showTextInput() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("添加文字"),
          content: Container(
            height: 200,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 200,
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                    ),
                    child: TextField(
                        controller: _textController,
                        decoration: InputDecoration(border: InputBorder.none),
                        maxLines: 20,
                        keyboardType: TextInputType.multiline),
                  )
                ],
              ),
            ),
          ),
          actions: [
            // 确认
            TextButton(
              onPressed: () {
                if (_textController.text == "") {
                  EasyLoading.showInfo("没有文字噢!");
                } else {
                  Navigator.pop(context);
                  setState(() {
                    stepArr.add(1);
                    drawStep++;
                    richArr.add(
                      TextCanvasContainer(_textController.text,
                          richArr.length - 1, stepArr.length - 1),
                    );
                    _textController.text = '';
                  });
                }
              },
              child: Text("确定"),
            ),
            // 取消
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("取消"),
            ),
          ],
        );
      },
    );
  }

  deleteComp(int index, int stepOrder) {
    setState(() {
      richArr.removeAt(index);
      stepArr.removeAt(stepOrder);
    });
  }
}

class LinerPainter extends CustomPainter {
  LinerPainter(this.path, this.config, {this.noteInfo});
  final List<Map<String, dynamic>> path;
  UI.Image? noteInfo;
  Map config;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..color = Colors.black;
    paint.strokeWidth = config["width"];
    final rect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
    canvas.clipRect(rect);
    // 有上次的笔记，就渲染成图片
    if (noteInfo != null) {
      canvas.drawImageNine(
          noteInfo!,
          Rect.fromLTWH(0, 0, double.parse(noteInfo!.width.toString()),
              double.parse(noteInfo!.height.toString())),
          Rect.fromLTWH(0, 0, size.width, size.height),
          paint);
    }
    path.forEach((item) {
      Path _path = Path();
      paint.strokeWidth = item["width"];
      paint.color = item["color"];
      if (item["type"] == "straight") {
        canvas.drawLine(item["data"][0], item["data"][1], paint);
      } else if (item["type"] == "rect") {
        canvas.drawRect(
            Rect.fromPoints(item["data"][0], item["data"][1]), paint);
      } else {
        for (int i = 0; i < item["data"].length; i++) {
          if (i == 0) {
            _path.moveTo(item["data"][i].dx, item["data"][i].dy);
          } else {
            _path.lineTo(item["data"][i].dx, item["data"][i].dy);
          }
        }
        canvas.drawPath(_path, paint);
      }
    });
  }

  @override
  bool shouldRepaint(LinerPainter oldDelegate) {
    // throw UnimplementedError();
    // return oldDelegate.path != path;
    return true;
  }
}
