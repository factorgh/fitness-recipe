import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:voltican_fitness/models/meal.dart';
import 'package:voltican_fitness/widgets/review_card.dart';

class MealDetailScreen extends StatefulWidget {
  const MealDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  State<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  double value = 3.8;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            bottom: PreferredSize(
                preferredSize: const Size.fromHeight(30),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  width: double.infinity,
                  height: 20,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white,
                  ),
                  child: Container(
                    width: 30,
                    height: 5,
                    margin: const EdgeInsets.symmetric(horizontal: 150),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black26,
                    ),
                  ),
                )),
            backgroundColor: Colors.white,
            expandedHeight: 300,
            pinned: true,
            toolbarHeight: 60,
            leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 20,
                height: 20,
                child: const Icon(Icons.arrow_back_ios_sharp, size: 20),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.meal.imageUrl,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              margin: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Text(
                        widget.meal.title,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.bookmark,
                        color: Colors.red,
                        size: 25,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      RatingStars(
                        value: value,
                        onValueChanged: (v) {
                          setState(() {
                            value = v;
                          });
                        },
                        starCount: 5,
                        starSpacing: 2,
                        valueLabelVisibility: true,
                        maxValue: 5,
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      const Text("(32 Reviews)")
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker \n"
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker  .",
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 120,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Cucumber (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Cabbage (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Carrot (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Tomato (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Procedures',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 120,
                    height: 3,
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(20)),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    '1. psum passages, and more recently with desk  ',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '2. psum passages, and more recently with desk',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '3. psum passages, and more recently with desk ',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '4. psum passages, and more recently with desk ',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  const Text(
                    'Reviews',
                    style: TextStyle(fontSize: 20),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const ReviewCard(),
                  const SizedBox(
                    height: 10,
                  ),
                  const ReviewCard(),
                  const SizedBox(
                    height: 10,
                  ),
                  const ReviewCard(),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
