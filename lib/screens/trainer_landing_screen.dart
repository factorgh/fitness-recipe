import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/screens/notify_screen.dart';

import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/widgets/category_slider.dart';
import 'package:voltican_fitness/widgets/new_recipe_slider.dart';
import 'package:voltican_fitness/widgets/slider_trainer_landing.dart';
import 'package:badges/badges.dart' as badges;

class TrainerLandeingScreen extends ConsumerStatefulWidget {
  const TrainerLandeingScreen({super.key});

  @override
  ConsumerState<TrainerLandeingScreen> createState() =>
      _TrainerLandeingScreenState();
}

class _TrainerLandeingScreenState extends ConsumerState<TrainerLandeingScreen> {
  final AuthService authService = AuthService();
  @override
  void initState() {
    super.initState();
    authService.getMe(context: context, ref: ref);
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final categories = [
      'Breakfast',
      'Deserts',
      'Lunch',
      'Dinner',
      'Others',
    ];
    final categoryimages = [
      "assets/images/recipes/r6.jpg",
      "assets/images/recipes/r1.jpg",
      "assets/images/recipes/r4.jpg",
      "assets/images/recipes/r5.jpg",
      "assets/images/recipes/r2.jpg",
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
    }

    void handleRecipSelected(String category) {
      // Handle category selection
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //         builder: (context) => const TrainerMealDetailScreen(
      //               meal: Meal(
      //                   id: 'm2',
      //                   imageUrl:
      //                       "https://cdn.pixabay.com/photo/2017/03/27/13/54/bread-2178874_640.jpg",
      //                   ingredients: ["potatos", "fries"],
      //                   title: "Sandwich and Fries"),
      //             )));
    }

    void handleTrainerSelected(String trainer) {
      // Handle category selection
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
                        Row(
                          children: [
                            const CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  AssetImage('assets/images/pf2.jpg'),
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Hello, ${user?.fullName}',
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                const Text(
                                  'Check amazing recipes..',
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            ),
                          ],
                        ),
                        badges.Badge(
                          position:
                              badges.BadgePosition.topEnd(top: -2, end: 1),
                          showBadge: true,
                          badgeContent: const Text(
                            "4",
                            style: TextStyle(color: Colors.white),
                          ),
                          badgeAnimation: const badges.BadgeAnimation.slide(
                            animationDuration: Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                          badgeStyle: badges.BadgeStyle(
                            shape: badges.BadgeShape.circle,
                            badgeColor: Colors.blueGrey[900]!,
                            padding: const EdgeInsets.all(6),
                            borderRadius: BorderRadius.circular(8),
                            elevation: 3,
                          ),
                          child: IconButton(
                            icon: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 25,
                            ),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => NotificationsScreen()));
                            },
                          ),
                        )
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
              images: categoryimages,
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
