import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/meal.dart';

import 'package:voltican_fitness/screens/notify_screen.dart';
import 'package:voltican_fitness/screens/trainer_meal_details.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/category_slider.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/new_recipe_slider.dart';
import 'package:voltican_fitness/Features/auth/presentation/widgets/slider_trainer_landing.dart';

class TrainerLandeingScreen extends StatelessWidget {
  const TrainerLandeingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      'Breakfast',
      'Deserts',
      'Lunch',
      'Dinner',
      'Others',
    ];
    final recipes = [
      'Breakfast',
      'Deserts',
      'Lunch',
      'Dinner',
      'Others',
    ];
    final trainers = [
      'Albert M.',
      'Ernest A.',
      'Lucis M.',
      'Mills A.',
      'William A.',
    ];
    final images = [
      "assets/images/pf.jpg",
      "assets/images/pf2.jpg",
      "assets/images/pf3.jpg",
      "assets/images/pf4.jpg",
      "assets/images/pf5.jpg",
    ];
    final emails = [
      'albert.m@example.com',
      'ernest.m@example.com.',
      'lucy.m@example.com',
      'mills.m@example.com',
      'william.m@example.com',
    ];

    void handleCategorySelected(String category) {
      // Handle category selection
      print('Selected category: $category');
    }

    void handleRecipSelected(String category) {
      // Handle category selection
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const TrainerMealDetailScreen(
                    meal: Meal(
                        id: 'm2',
                        imageUrl:
                            "https://cdn.pixabay.com/photo/2017/03/27/13/54/bread-2178874_640.jpg",
                        ingredients: ["potatos", "fries"],
                        title: "Sandwich and Fries"),
                  )));
      print('Selected category: $category');
    }

    void handleTrainerSelected(String trainer) {
      // Handle category selection
      print('Selected category: $trainer');
    }

    return Scaffold(
        body: SafeArea(
      child: SingleChildScrollView(
        child: Column(
          children: [
            // First Row
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: Colors.red[400],
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/pf2.jpg'),
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello, Jennifer',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                Text(
                                  'Check amazing recipes..',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: Colors.white,
                          ),
                          child: IconButton(
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        NotificationsScreen()));
                              },
                              icon: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: Colors.black,
                                  size: 30)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Container(
                    height: 50,
                    width: 280,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15)),
                    child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search),
                              label: Text("Search recipes..")),
                        )),
                  )
                ],
              ),
            ),
            // Second Row
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Explore All Recipes",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        color: Colors.red[600], fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),

            // Categories
            CategorySlider(
              categories: categories,
              onCategorySelected: handleCategorySelected,
            ),
            // New recipe slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Popular ",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    "See All",
                    style: TextStyle(
                        color: Colors.red[800], fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            // New recipe slider
            NewRecipeSlider(
                recipes: recipes, onCategorySelected: handleRecipSelected),
            const SizedBox(
              height: 20,
            ),
            // Trainers section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Top Trainers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            // Trainers
            SliderTrainerLanding(
              emails: emails,
              recipes: trainers,
              onTrainerSelected: handleTrainerSelected,
              images: images,
            ),
          ],
        ),
      ),
    ));
  }
}
