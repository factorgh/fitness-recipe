import 'package:flutter/material.dart';

class CapitalizeFirstLetter extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const CapitalizeFirstLetter({
    super.key,
    required this.text,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    // Capitalize the first letter
    final capitalizedText =
        text.isNotEmpty ? text[0].toUpperCase() + text.substring(1) : text;

    return Text(
      capitalizedText,
      overflow: TextOverflow.ellipsis,
      style: style,
    );
  }
}
