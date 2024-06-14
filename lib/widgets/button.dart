import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final Color backColor;
  final String text;
  final Color textColor;

  const ButtonWidget(
      {super.key,
      required this.backColor,
      required this.text,
      required this.textColor});

  @override
  Widget build(BuildContext context) {
    return 
    
    Container(
      width: double.maxFinite,
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
