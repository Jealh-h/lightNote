import 'package:flutter/material.dart';

class WriteNote extends StatefulWidget {
  WriteNote({Key? key, required this.height}) : super(key: key);
  double height;
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
  ScrollController sc = ScrollController();
  // 绘制的路径
  List<List<Offset>> path = [];
  @override
  void initState() {
    // TODO: implement initState
  }

  // @override
  // Widget build(BuildContext context) {
  //   Size size = MediaQuery.of(context).size;
  //   return Scaffold(
  //       appBar: AppBar(),
  //       body: Stack(
  //         children: [
  //           SingleChildScrollView(
  //             controller: sc,
  //             child:
  //                 Stack(alignment: AlignmentDirectional.topCenter, children: [
  //               Padding(
  //                 padding: EdgeInsets.all(20),
  //                 child: GestureDetector(
  //                   onPanDown: (DragDownDetails e) {
  //                     path.add([e.localPosition]);
  //                   },
  //                   //手指滑动时会触发此回调
  //                   onPanUpdate: (DragUpdateDetails e) {
  //                     //用户手指滑动时
  //                     setState(() {
  //                       path[path.length - 1].add(e.localPosition);
  //                     });
  //                   },
  //                   onPanEnd: (DragEndDetails e) {
  //                     //打印滑动结束时在x、y轴上的速度
  //                     currentPath = [];
  //                     print("end");
  //                   },
  //                   child: Container(
  //                     color: Colors.transparent,
  //                     width: double.infinity,
  //                     height: widget.height,
  //                     child: CustomPaint(
  //                       isComplex: true,
  //                       willChange: true,
  //                       foregroundPainter: LinerPainter(path),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ]),
  //           ),
  //           _buildErase(),
  //           Positioned(
  //             left: 20,
  //             bottom: 20,
  //             child: TextButton(
  //               child: Text("添加"),
  //               onPressed: () {
  //                 setState(() {
  //                   widget.height += 200;
  //                   print(MediaQuery.of(context).size.height);
  //                   print(widget.height);
  //                 });
  //               },
  //             ),
  //           ),
  //         ],
  //       ));
  // }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("123"),
      ),
    );
  }
}

class LinerPainter extends CustomPainter {
  LinerPainter(this.path);
  final List<List<Offset>> path;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 2
      ..color = Colors.black;

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
    // // TODO: implement shouldRepaint
    // throw UnimplementedError();
    // return oldDelegate.path != path;
    return true;
  }
}
