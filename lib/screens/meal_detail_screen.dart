// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/user_recipes.dart';

import 'package:voltican_fitness/screens/edit_recipe_screen.dart';
import 'package:voltican_fitness/screens/meal_creation.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/widgets/button.dart';

class MealDetailScreen extends ConsumerStatefulWidget {
  const MealDetailScreen({super.key, required this.meal});
  final Recipe meal;

  @override
  ConsumerState<MealDetailScreen> createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends ConsumerState<MealDetailScreen> {
  double value = 3.8;
  bool isPrivate = false;
  bool isFollowing = false;

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black87),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure you want to delete this item?',
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: const Text('Delete'),
              onPressed: () async {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                await ref
                    .read(userRecipesProvider.notifier)
                    .deleteRecipe(widget.meal.id!);
                Navigator.of(context).pop();

                // await Future.delayed(Duration.zero, () {
                //   ref.read(userRecipesProvider.notifier).loadUserRecipes();
                // });
              },
            ),
          ],
        );
      },
    );
  }

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
                    topRight: Radius.circular(20),
                  ),
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
              ),
            ),
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
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                width: 20,
                height: 20,
                child: const Icon(Icons.arrow_back_outlined,
                    size: 30, color: Colors.white),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.meal.imageUrl,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    right: 10,
                    top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.brown,
                            size: 30,
                          ),
                          onPressed: () {
                            // Add share functionality here
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(color: Colors.white),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Text(
                        widget.meal.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.meal.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        isPrivate ? 'Private' : 'Public',
                        style: const TextStyle(fontSize: 16),
                      ),
                      Switch(
                        value: isPrivate,
                        onChanged: (value) {
                          setState(() {
                            isPrivate = value;
                          });

                          if (value) {
                            // Show alert dialog when changing from Public to Private
                            NativeAlerts().showSuccessAlert(context,
                                'Your settings have changed from Public to Private');
                            // Show alert dialog when changing from Private to
                          } else {
                            NativeAlerts().showSuccessAlert(context,
                                'Your settings have changed from Private to Public.');
                            // Show alert dialog when changing from Private to Public
                          }
                        },
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  const Row(
                    children: [
                      Icon(
                        Icons.no_food_sharp,
                        size: 25,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Ingredients',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: widget.meal.ingredients.map((ingredient) {
                        return Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            const SizedBox(width: 12.0),
                            Expanded(
                              child: Text(
                                ingredient,
                                style: const TextStyle(
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(
                        Icons.text_snippet,
                        size: 25,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Instructions',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.meal.instructions,
                    ),
                  ),
                  // Nutitional Info  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(
                        Icons.text_snippet,
                        size: 25,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Nutritional facts',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.meal.facts,
                    ),
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => EditRecipeScreen(
                                recipe: widget.meal,
                              )));
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Update',
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              MealCreationScreen(selectedDay: DateTime.now())));
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Assign',
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      _showDeleteConfirmationDialog(context);
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Delete',
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
