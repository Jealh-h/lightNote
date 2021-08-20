import 'package:flutter/material.dart';
import 'package:lightnote/constant.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.text,
    this.press,
    this.color = PrimaryColor,
    this.padding = const EdgeInsets.all(DefaultPadding * 0.75),
  });

  final String text;
  final VoidCallback? press;
  final color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(40)),
      ),
      minWidth: double.infinity,
      color: color,
      padding: padding,
      disabledColor: Colors.black38,
      disabledTextColor: Colors.black12,
      onPressed: press,
      child: Text(
        text,
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
