import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lightnote/constant.dart';

class TextCanvasContainer extends StatefulWidget {
  TextCanvasContainer(this.text, this.index, this.stepOrder, {Key? key})
      : super(key: key);
  final String text;
  int index;
  int stepOrder;
  @override
  _TextCanvasContainerState createState() => _TextCanvasContainerState();
}

class _TextCanvasContainerState extends State<TextCanvasContainer> {
  double x = 100, y = 100;
  bool isLongPress = false;
  Offset longPressStart = Offset(0, 0);
  double scaleFactor = 1;
  final GlobalKey globalKey = GlobalKey();

  bool showDelete = false;
  int fontSize = 14;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: y,
        left: x,
        child: Row(
          children: [
            _buildDropMenuIcon(),
            GestureDetector(
              onTap: () {
                setState(() {
                  showDelete = !showDelete;
                });
              },
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
                  scaleFactor += 0.1;
                });
              },
              onLongPressMoveUpdate: (e) {
                setState(() {
                  x = e.globalPosition.dx - longPressStart.dx;
                  y = e.globalPosition.dy - 80 - longPressStart.dy;
                });
              },
              onLongPressEnd: (e) {
                setState(() {
                  scaleFactor -= 0.1;
                });
              },
              child: AnimatedContainer(
                duration: Duration(milliseconds: 250),
                transform: Matrix4.translationValues(0, 0, 0)
                  ..scale(scaleFactor),
                child: Container(
                  key: globalKey,
                  alignment: Alignment.center,
                  child: Text(
                    widget.text,
                    style:
                        TextStyle(fontSize: double.parse(fontSize.toString())),
                  ),
                ),
              ),
            ),
          ],
        ));
  }

  // 构建删除图标
  Widget _buildDropMenuIcon() {
    var size = [];
    for (int i = 14; i < 48; i += 2) {
      size.add(i);
    }
    return showDelete
        ? GestureDetector(
            child: DropdownButton(
              value: fontSize,
              onChanged: (value) {
                setState(() {
                  fontSize = value as int;
                });
              },
              items: size
                  .map((e) => DropdownMenuItem(
                        value: e,
                        child: Text("$e"),
                      ))
                  .toList(),
            ),
          )
        : Text("");
  }
}
