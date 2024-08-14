// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/edit_recipe_screen.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';
import 'package:voltican_fitness/widgets/button.dart';

class TrainerMealDetailScreen extends ConsumerStatefulWidget {
  const TrainerMealDetailScreen({super.key, required this.meal});
  final Recipe meal;

  @override
  ConsumerState<TrainerMealDetailScreen> createState() =>
      _TrainerMealDetailScreenState();
}

class _TrainerMealDetailScreenState
    extends ConsumerState<TrainerMealDetailScreen> {
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
              onPressed: () {
                // Perform the delete action
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    return Scaffold(
      // floatingActionButton: SpeedDial(
      //   animatedIcon: AnimatedIcons.menu_close,
      //   animatedIconTheme: const IconThemeData(size: 28.0),
      //   backgroundColor: Colors.green[900],
      //   visible: true,
      //   curve: Curves.bounceInOut,
      //   children: [
      //     SpeedDialChild(
      //       child: const Icon(Icons.accessibility),
      //       backgroundColor: Colors.blue,
      //       label: 'Accessibility',
      //       onTap: () {
      //         print('Accessibility tapped');
      //       },
      //     ),
      //     SpeedDialChild(
      //       child: const Icon(Icons.add),
      //       backgroundColor: Colors.red,
      //       label: 'Add',
      //       onTap: () {
      //         print('Add tapped');
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
                  Positioned(
                    right: 10,
                    top: 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: Icon(
                            isFollowing
                                ? Icons.person_remove
                                : Icons.person_add,
                            color: Colors.white,
                            size: 30,
                          ),
                          onPressed: () {
                            setState(() {
                              isFollowing = !isFollowing;
                            });
                          },
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.red, // background color
                            backgroundColor: Colors.white, // text color
                          ),
                          onPressed: () {
                            setState(() {
                              isFollowing = !isFollowing;
                            });
                          },
                          child: Text(isFollowing ? 'Following' : 'Follow'),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.share,
                            color: Colors.white,
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
                              RatingStars(
                                value: value,
                                onValueChanged: (v) {
                                  setState(() {
                                    value = v;
                                  });
                                },
                                starCount: 5,
                                starSize: 15,
                                starSpacing: 2,
                                valueLabelVisibility: false,
                                maxValue: 5,
                                starOffColor: const Color(0xffe7e8ea),
                                starColor: Colors.yellow,
                              ),
                              const SizedBox(width: 10),
                              const Text("(32 Reviews)",
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
                          // Contact section goes here
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

                  // Expanded(
                  //   child: ListView.builder(
                  //     itemCount: widget.meal.ingredients.length,
                  //     itemBuilder: (context, index) {
                  //       final List<String> ingredientsList =
                  //           widget.meal.ingredients;
                  //       return ListTile(
                  //         title: Text(ingredientsList[index]),
                  //       );
                  //     },
                  //   ),
                  // ),
                  SizedBox(
                    height: 100, // Set a specific height
                    child: ListView.builder(
                      itemCount: widget.meal.ingredients.length,
                      itemBuilder: (context, index) {
                        final List<String> ingredientsList =
                            widget.meal.ingredients;
                        return ListTile(
                          title: Text(ingredientsList[index]),
                        );
                      },
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
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              EditRecipeScreen(recipe: widget.meal)));
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Edit and Assign',
                        textColor: Colors.white),
                  ),

                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await ref
                          .read(savedRecipesProvider.notifier)
                          .saveRecipe(user!.id, widget.meal);
                      showSnack(context, 'Recipe has been saved successfully');
                      // Navigator.of(context).push(MaterialPageRoute(
                      //     builder: (context) => const AssignRecipeScreen()));
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Save',
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
