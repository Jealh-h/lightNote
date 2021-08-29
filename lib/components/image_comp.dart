import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightnote/constant.dart';

class ImageContainer extends StatefulWidget {
  ImageContainer({Key? key, required this.image}) : super(key: key);
  var image;
  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  double x = 0, y = 0;
  bool isLongPress = false;
  Offset longPressStart = Offset(0, 0);
  double scaleFactor = 1;
  bool showDelete = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y,
      left: x,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TextButton(onPressed: () {}, child: Text("删除")),
          GestureDetector(
            // onLongPress: () {
            //   setState(() {
            //     isLongPress = true;
            //   });
            //   print("long press");
            // },
            onScaleStart: (e) {},
            onScaleUpdate: (e) {
              print(e);
              setState(() {
                if (e.scale > 0.3) scaleFactor = e.scale;
              });
            },
            onScaleEnd: (e) {
              print(e);
            },
            onLongPressStart: (e) {
              setState(() {
                longPressStart = e.localPosition;
                scaleFactor += 0.05;
              });
            },
            onLongPressMoveUpdate: (e) {
              setState(() {
                // var dis = showDelete ? 32 : 0;
                // x = e.globalPosition.dx - longPressStart.dx - dis;
                x = e.globalPosition.dx - longPressStart.dx;
                y = e.globalPosition.dy - 80 - longPressStart.dy;
              });
            },
            onLongPressEnd: (e) {
              setState(() {
                scaleFactor -= 0.05;
              });
            },
            child: AnimatedContainer(
              duration: Duration(milliseconds: 250),
              transform: Matrix4.translationValues(0, 0, 0)..scale(scaleFactor),
              child: Container(
                width: 200,
                child: Image.memory(
                  widget.image,
                  fit: BoxFit.fitWidth,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
