import 'package:flutter/material.dart';
import 'package:lightnote/constant.dart';

class TailInputContainer extends StatefulWidget {
  final String hintText;
  final IconData icon;
  final IconData? suffixIcon;
  final ValueChanged<String> onChanged;
  final TextEditingController controller;
  const TailInputContainer({
    required this.controller,
    required this.hintText,
    this.icon = Icons.lock,
    this.suffixIcon = Icons.visibility,
    required this.onChanged,
  });

  @override
  State<StatefulWidget> createState() {
    return TailInputContainerState();
  }
}

class TailInputContainerState extends State<TailInputContainer> {
  bool _obscureText = true;

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
        controller: widget.controller,
        onChanged: widget.onChanged,
        obscureText: _obscureText,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: widget.hintText,
          icon: Icon(
            widget.icon,
            color: IconColor,
          ),
          suffixIcon: IconButton(
            icon: GestureDetector(
              child:
                  Icon(_obscureText ? Icons.visibility_off : widget.suffixIcon),
            ),
            color: IconColor,
            onPressed: () => setState(() {
              _obscureText = !_obscureText;
            }),
          ),
        ),
      ),
    );
  }
}
