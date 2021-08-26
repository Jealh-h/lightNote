import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class ImageContainer extends StatefulWidget {
  const ImageContainer({Key? key}) : super(key: key);

  @override
  _ImageContainerState createState() => _ImageContainerState();
}

class _ImageContainerState extends State<ImageContainer> {
  double x = 0, y = 0;
  bool isLongPress = false;
  Offset longPressStart = Offset(0, 0);
  double scaleFactor = 1;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: y,
      left: x,
      child: GestureDetector(
        // onLongPress: () {
        //   setState(() {
        //     isLongPress = true;
        //   });
        //   print("long press");
        // },
        onLongPressStart: (e) {
          setState(() {
            longPressStart = e.localPosition;
            scaleFactor = 1.2;
          });
        },
        onLongPressMoveUpdate: (e) {
          if (scaleFactor != 1) {
            setState(() {
              x = e.globalPosition.dx - longPressStart.dx;
              y = e.globalPosition.dy - 80 - longPressStart.dy;
            });
          }
        },
        onLongPressEnd: (e) {
          setState(() {
            scaleFactor = 1;
          });
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 250),
          transform: Matrix4.translationValues(0, 0, 0)..scale(scaleFactor),
          child: Container(
            // width: 100,
            // height: 100,
            child: Image.asset("assets/images/empty.png"),
          ),
        ),
      ),
    );
  }
}
