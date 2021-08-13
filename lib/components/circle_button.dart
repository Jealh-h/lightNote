import 'package:flutter/material.dart';

class CircleButton extends StatelessWidget {
  final icon;
  final press;
  final backgroundColor;
  CircleButton(
      {required this.icon, required this.press, required this.backgroundColor});
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: icon,
      style: ButtonStyle(
          shadowColor: MaterialStateProperty.all(Colors.black26),
          backgroundColor: MaterialStateProperty.all(backgroundColor),
          padding: MaterialStateProperty.all(EdgeInsets.all(0)),
          minimumSize: MaterialStateProperty.all(Size(30, 30)),
          shape: MaterialStateProperty.all(CircleBorder()),
          elevation: MaterialStateProperty.all(20)),
      onPressed: press,
    );
  }
}
