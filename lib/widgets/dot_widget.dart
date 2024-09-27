import 'package:flutter/material.dart';

class DotWidget extends StatelessWidget {
  final double dotSize;
  final Color dotColor;
  const DotWidget({super.key, required this.dotSize, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: dotSize,
      height: 30,
      decoration: BoxDecoration(
        color: dotColor,
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}
