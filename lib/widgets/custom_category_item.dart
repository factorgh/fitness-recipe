import 'package:flutter/material.dart';

class MyWidget extends StatelessWidget {
  final String title;
  const MyWidget({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Image(image: AssetImage("assets/images/background.jpg")),
        Positioned(
            child: Text(
          title,
          style: const TextStyle(color: Colors.white),
        ))
      ],
    );
  }
}
