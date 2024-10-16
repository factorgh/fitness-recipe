import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final Color backColor;
  final String text;
  final Color textColor;
  final double width;
  final double size;
  final VoidCallback? onPressed;

  const CustomButton({
    super.key,
    required this.backColor,
    required this.text,
    required this.width,
    required this.size,
    required this.textColor,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: MediaQuery.of(context).size.height / 16,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0, // remove shadow
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textColor, fontSize: size),
          ),
        ),
      ),
    );
  }
}
