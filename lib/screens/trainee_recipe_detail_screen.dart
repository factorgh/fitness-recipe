// ignore_for_file: use_build_context_synchronously, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/button.dart';

class TraineeRecipeDetailScreen extends ConsumerStatefulWidget {
  const TraineeRecipeDetailScreen({super.key, required this.meal});
  final Recipe meal;

  @override
  ConsumerState<TraineeRecipeDetailScreen> createState() =>
      _TraineeRecipeDetailScreenState();
}

class _TraineeRecipeDetailScreenState
    extends ConsumerState<TraineeRecipeDetailScreen> {
  double value = 3.8;
  bool isPrivate = false;
  bool isFollowing = false;
  RecipeService recipeService = RecipeService();

  @override
  void initState() {
    _fetchSavedRecipes();
    super.initState();
  }

  void _fetchSavedRecipes() {
    final user = ref.read(userProvider);
    if (user == null) {
      print('Error: User is null');
      return;
    }
    final userId = user.id;
    ref.read(savedRecipesProvider.notifier).loadSavedRecipes(userId);
  }

  void _showCommentDialog() async {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Leave a Comment'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Please leave a comment about the recipe:'),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Write your comment here',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Skip'),
            ),
            TextButton(
              onPressed: () async {
                String comment = commentController.text;
                if (comment.isNotEmpty) {
                  // For example, save the comment to your backend or local storage
                  showSnack(context, 'Comment submitted successfully');
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showRatingDialog() async {
    final TextEditingController commentController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
              child: Text(
            'Leave your Review',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 25),
          )),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // RatingStars(
              //   value: value,
              //   onValueChanged: (v) {
              //     setState(() {
              //       value = v;
              //     });
              //   },
              //   starCount: 5,
              //   starSize: 15,
              //   starSpacing: 2,
              //   valueLabelVisibility: false,
              //   maxValue: 5,
              //   starOffColor: const Color(0xffe7e8ea),
              //   starColor: Colors.yellow,
              // ),
              const SizedBox(height: 10),
              TextField(
                controller: commentController,
                decoration: const InputDecoration(
                  hintText: 'Write your review here',
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Skip')),
            ),
            const Spacer(),
            TextButton(
              onPressed: () {
                String comment = commentController.text;
                if (comment.isNotEmpty) {
                  // Handle comment submission here
                  showSnack(context, 'Review submitted successfully');
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Post')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final savedRecipes = ref.watch(savedRecipesProvider);
    return Scaffold(
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   animatedIconTheme: const IconThemeData(size: 28.0),
      //   backgroundColor: Colors.green[900],
      //   visible: true,
      //   curve: Curves.bounceInOut,
      //   children: [
      //     SpeedDialChild(
      //       child: const Icon(Icons.bookmark_border_rounded),
      //       backgroundColor: Colors.blue,
      //       label: 'Save Recipe',
      //       onTap: () async {

      //       },
      //     ),
      //   ],
      // ),
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.meal.title,
                        style: const TextStyle(
                          fontSize: 23,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.black12, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 5),
                          child: Column(
                            children: [
                              RatingBar.builder(
                                initialRating: 3,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 15,
                                itemPadding:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                onRatingUpdate: (rating) {
                                  recipeService.rateRecipe(
                                      context: context,
                                      recipeId: widget.meal.id!,
                                      rating: rating);
                                  print(rating);
                                  _showRatingDialog();
                                },
                              ),
                              const SizedBox(width: 10),
                              const Text("(No Reviews)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 12)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Recipe by",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage:
                                AssetImage('assets/images/pf2.jpg'),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Dianne Russell",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              Text(
                                "Dian",
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                          Spacer(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    widget.meal.description,
                    style: const TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 0.5,
                    decoration: BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100, // Set a specific height
                      child: ListView.builder(
                        itemCount: widget.meal.ingredients.length,
                        itemBuilder: (context, index) {
                          final List<String> ingredientsList =
                              widget.meal.ingredients;
                          return Container(
                            margin: const EdgeInsets.only(
                                bottom: 8.0), // Space between items
                            padding: const EdgeInsets.all(
                                12.0), // Padding inside each item
                            decoration: BoxDecoration(
                              color: Colors.white, // Background color
                              borderRadius:
                                  BorderRadius.circular(8.0), // Rounded corners
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.2),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: const Offset(0, 3), // Shadow position
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons
                                      .check_circle_outline, // Icon to indicate completion or presence
                                  color: Colors.green,
                                ),
                                const SizedBox(
                                    width: 12.0), // Space between icon and text
                                Expanded(
                                  child: Text(
                                    ingredientsList[index],
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
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
                  Text(
                    widget.meal.instructions,
                  ),
                  // Nutritional facts
                  const SizedBox(height: 30),
                  const Row(
                    children: [
                      Icon(
                        Icons.fact_check,
                        size: 25,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Nutritional Facts',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.meal.facts,
                  ),
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () async {
                      // Check if recipe is already saved
                      if (savedRecipes.contains(widget.meal)) {
                        showSnack(context, 'Recipe is already saved');
                        return;
                      }

                      await ref
                          .read(savedRecipesProvider.notifier)
                          .saveRecipe(user!.id, widget.meal);
                      showSnack(context, 'Recipe has been saved successfully');
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Save',
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
