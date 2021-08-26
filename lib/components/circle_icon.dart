import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CircleIcon extends StatelessWidget {
  CircleIcon({Key? key, required this.color, required this.icon})
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
