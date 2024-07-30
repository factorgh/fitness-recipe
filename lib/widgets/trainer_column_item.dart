import 'package:flutter/material.dart';

class TrainerColumnItem extends StatelessWidget {
  final String title;
  final String count;
  const TrainerColumnItem(
      {super.key, required this.count, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
        const SizedBox(
          height: 10,
        ),
        Text(title)
      ],
    );
  }
}
