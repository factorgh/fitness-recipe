import 'package:flutter/material.dart';

class SimpleButton extends StatelessWidget {
  final String title;
  final Color backColor;
  final double size;
  final Color textColor;

  const SimpleButton(
      {super.key,
      required this.title,
      required this.backColor,
      required this.size,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: backColor,
          border: Border.all(color: Colors.black54),
          borderRadius: BorderRadius.circular(40)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Text(
          title,
          style: TextStyle(color: textColor),
        ),
      ),
    );
  }
}
