import 'package:flutter/material.dart';

class MealPeriodCard extends StatelessWidget {
  const MealPeriodCard(
      {super.key,
      required this.mealPeriod,
      required this.time1,
      required this.time2,
      required this.images});
  final String mealPeriod;
  final String time1;
  final String time2;
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
                        SizedBox(width: MediaQuery.of(context).size.width / 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 20),
                            Text(
                              time1,
                              style: const TextStyle(fontSize: 14),
                            ),
                            const Text(
                              '-',
                              style: TextStyle(fontSize: 14),
                            ),
                            Text(
                              time2,
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
