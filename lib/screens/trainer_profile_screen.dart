import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';

import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/widgets/recipe_item.dart';

class TrainerProfileScreen extends StatelessWidget {
  final User user;
  TrainerProfileScreen({super.key, required this.user});
  final List<Recipe> userRecipes = [];

  void selectMeal(BuildContext context, Recipe meal) {
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
                    Text("Albert Smith",
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
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
              itemCount: userRecipes.length,
              itemBuilder: (context, index) => RecipeItem(
                meal: userRecipes[index],
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
