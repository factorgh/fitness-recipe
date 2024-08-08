import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voltican_fitness/data/dummy_data.dart';
import 'package:voltican_fitness/models 2/meal.dart';

import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/widgets/meal_item.dart';

class TrainerProfileScreen extends StatelessWidget {
  TrainerProfileScreen({super.key});

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainerMealDetailScreen(meal: meal),
    ));
  }

  final List<String> photos = List.generate(
      6,
      (index) =>
          'https://images.pexels.com/photos/3838633/pexels-photo-3838633.jpeg?auto=compress&cs=tinysrgb&w=800');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text('Trainer Profile'),
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: CachedNetworkImageProvider(
                          "https://images.pexels.com/photos/428361/pexels-photo-428361.jpeg?auto=compress&cs=tinysrgb&w=800"),
                    ),
                    SizedBox(height: 10),
                    Text("Albert Smith", style: TextStyle(fontSize: 12)),
                    SizedBox(height: 10),
                    Text("albert@example.com", style: TextStyle(fontSize: 12)),
                  ],
                ),
                SizedBox(width: 20),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: dummyMeals.length,
              itemBuilder: (context, index) => MealItem(
                meal: dummyMeals[index],
                selectMeal: (meal) {
                  selectMeal(context, meal);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
