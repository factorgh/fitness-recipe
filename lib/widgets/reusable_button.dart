import 'package:flutter/material.dart';

class Reusablebutton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;
  const Reusablebutton(
      {super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10.0,
        ),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 15),
              backgroundColor: Colors.redAccent, // Background color
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: onPressed,
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            )),
      ),
    );
  }
}
