// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/services/auth_service.dart';

class NewRecipeSlider extends StatefulWidget {
  final List<Recipe> recipes; // Updated to List<Recipe>
  final Function(Recipe) onCategorySelected;

  const NewRecipeSlider({
    super.key,
    required this.recipes,
    required this.onCategorySelected,
  });

  @override
  State<NewRecipeSlider> createState() => _NewRecipeSliderState();
}

class _NewRecipeSliderState extends State<NewRecipeSlider> {
  final AuthService authService = AuthService();
  Map<String, String> userNames = {}; // Store user names by user ID

  @override
  void initState() {
    super.initState();
    _fetchUsers();
  }

  void _fetchUsers() async {
    final userIds = widget.recipes.map((recipe) {
      return recipe.createdBy;
    }).toSet();

    final futures = userIds.map((userId) {
      return authService.getUser(
        userId: userId,
        onSuccess: (fetchedUser) {
          setState(() {
            userNames[userId] = fetchedUser.username;
          });
        },
      );
    }).toList();

    await Future.wait(futures);
  }

  @override
  Widget build(BuildContext context) {
    return widget.recipes.isEmpty
        ? SizedBox(
            height: 150,
            child: Center(
              child: Text(
                'No recipes available',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[600],
                ),
              ),
            ),
          )
        : Container(
            height: 200, // Adjust height as needed
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.recipes.length,
              itemBuilder: (context, index) {
                return _buildRecipeItem(
                  context,
                  widget.recipes[index],
                );
              },
            ),
          );
  }

  Widget _buildRecipeItem(BuildContext context, Recipe recipe) {
    final userName = userNames[recipe.createdBy] ?? 'Unknown';
    print(userName);

    return GestureDetector(
      onTap: () => widget.onCategorySelected(recipe),
      child: Container(
        width: 330, // Adjust width as needed
        margin: const EdgeInsets.symmetric(horizontal: 10),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                image: DecorationImage(
                  image: NetworkImage(recipe.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 10,
              left: 8,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 30,
                        width: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              const SizedBox(width: 5),
                              const Icon(
                                Icons.star,
                                size: 20,
                                color: Colors.amber,
                              ),
                              Text(
                                '${recipe.averageRating.toStringAsFixed(1)} (1k+ Reviews)',
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 120),
                      // Add Favorite Icon
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.favorite_border_outlined,
                              color: Colors.black12, size: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 70,
                decoration: BoxDecoration(
                  color: Colors.white54,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipe.title,
                            style: const TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.timer,
                                color: Colors.amber,
                              ),
                              Text(
                                "35 min", // Use recipe.duration
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                ".",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
