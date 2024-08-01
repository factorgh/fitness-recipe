import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:voltican_fitness/models/meal.dart';
import 'package:voltican_fitness/screens/assign_recipe_screen.dart';
import 'package:voltican_fitness/screens/edit_recipe_screen.dart';
import 'package:voltican_fitness/widgets/button.dart';

class TrainerMealDetailScreen extends StatefulWidget {
  const TrainerMealDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  State<TrainerMealDetailScreen> createState() =>
      _TrainerMealDetailScreenState();
}

class _TrainerMealDetailScreenState extends State<TrainerMealDetailScreen> {
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
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                  ),
                  const Text(
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker \n"
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker  .",
                    style: TextStyle(color: Colors.black38),
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
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //   children: [
                  //     const Text(
                  //       'Private',
                  //       style: TextStyle(fontSize: 16),
                  //     ),
                  //     Switch(
                  //       value: isPrivate,
                  //       onChanged: (value) {
                  //         setState(() {
                  //           isPrivate = value;
                  //         });
                  //       },
                  //     ),
                  //   ],
                  // ),

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
                  const Text(
                    '1 Cucumber (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '2 Cups of rice',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '2 teaspoons of honey',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    '1 tablespoon of salt',
                    style: TextStyle(color: Colors.black38),
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
                  const SizedBox(height: 30),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const EditRecipeScreen()));
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Edit and Assign',
                        textColor: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const AssignRecipeScreen()));
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
