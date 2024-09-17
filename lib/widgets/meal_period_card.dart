import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/screens/trainee_recipe_detail_screen.dart';
import 'package:voltican_fitness/utils/conversions/capitalize_first.dart';

class MealPeriodCard extends StatelessWidget {
  const MealPeriodCard(
      {super.key,
      required this.mealPeriod,
      required this.time1,
      required this.time2,
      required this.image,
      this.recipe});

  final String mealPeriod;
  final String time1;
  final String time2;
  final String image;
  final Recipe? recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(
              width: 10,
            ),
            // Avatar on the left
            Column(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(image),
                ),
                const SizedBox(
                  height: 8,
                ),
                CapitalizeFirstLetter(
                  text: mealPeriod,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.redAccent,
                  ),
                )
              ],
            ),

            // Meal period and time
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Icon(Icons.access_time,
                          size: 20, color: Colors.black),
                      const SizedBox(width: 4),
                      Text(
                        time1,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.redAccent,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.redAccent),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) =>
                                TraineeRecipeDetailScreen(meal: recipe!)));
                      },
                      child: const Text(
                        'View recipe ',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            ),

            // Additional time or details (optional)
          ],
        ),
      ),
    );
  }
}
