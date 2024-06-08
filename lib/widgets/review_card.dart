import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';

class ReviewCard extends StatefulWidget {
  const ReviewCard({super.key});

  @override
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
  double value = 3.8;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.black12,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/profile.jpg'),
                ),
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      const Text('Rachael Lee'),
                      const Spacer(),
                      RatingStars(
                        value: value,
                        onValueChanged: (v) {
                          setState(() {
                            value = v;
                          });
                        },
                        starCount: 5,
                        starSpacing: 2,
                        valueLabelVisibility: false,
                        maxValue: 5,
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Text(
                    "psum passages, and more recently with everything that will make your grow  \n",
                    style: TextStyle(
                        color: Colors.black38, overflow: TextOverflow.ellipsis),
                  ),
                  const Text(
                    "psum passages, and more recently with everything that will make your grow  \n",
                    style: TextStyle(
                        color: Colors.black38, overflow: TextOverflow.ellipsis),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
