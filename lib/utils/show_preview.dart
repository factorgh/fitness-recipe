import 'dart:ui';

import 'package:flutter/material.dart';

class ShowPreview extends StatelessWidget {
  final String imageUrl;

  const ShowPreview({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            color: Colors.black.withOpacity(0.8),
          ),
        ),
        // Center the image
        Center(
          child: Container(
            constraints: const BoxConstraints(maxHeight: 500, maxWidth: 500),
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
        ),

        Positioned(
          top: 40,
          right: 20,
          child: IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.white,
              size: 30,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
      ],
    );
  }
}
