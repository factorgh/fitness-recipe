import 'package:flutter/material.dart';

class MealPeriodCard extends StatelessWidget {
  const MealPeriodCard(
      {super.key,
      required this.mealPeriod,
      required this.time,
      required this.images});
  final String mealPeriod;
  final String time;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          mealPeriod,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87),
                        ),
                        SizedBox(width: MediaQuery.of(context).size.width / 3),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            Text(
                              time,
                              style: const TextStyle(fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: images
                          .map((image) => CircleAvatar(
                                radius: 25,
                                backgroundImage: AssetImage(image),
                              ))
                          .toList(),
                    )
                  ],
                ),
              ),
              const Spacer(),
            ],
          ),
        ));
  }
}
