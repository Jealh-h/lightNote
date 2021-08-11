import 'package:flutter/material.dart';
import 'package:lightnote/constant.dart';

class TailInputContainer extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final IconData? suffixIcon;
  final ValueChanged<String> onChanged;
  const TailInputContainer({
    required this.hintText,
    this.icon = Icons.lock,
    this.suffixIcon = Icons.visibility,
    required this.onChanged,
  });
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        color: InputColor,
      ),
      width: size.width * 0.8,
      child: TextField(
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hintText,
          icon: Icon(
            icon,
            color: IconColor,
          ),
          suffixIcon: Icon(
            suffixIcon,
            color: IconColor,
          ),
        ),
      ),
    );
  }
}
