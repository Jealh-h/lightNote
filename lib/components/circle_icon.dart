import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  CircleIcon({Key? key, required Color this.color, required Icon this.icon})
      : super(key: key);
  Color color;
  Icon icon;
  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(color: color),
        child: icon,
      ),
    );
  }
}
