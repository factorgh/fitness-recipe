import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backColor;
  final String text;
  final Color textColor;
  final double width;
  const CustomButton(
      {super.key,
      required this.backColor,
      required this.text,
      required this.width,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: MediaQuery.of(context).size.height / 16,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: backColor),
      child: Center(
        child: Text(
          text,
          style: TextStyle(color: textColor, fontSize: 20),
        ),
      ),
    );
  }
}
