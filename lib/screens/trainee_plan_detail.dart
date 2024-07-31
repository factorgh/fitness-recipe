import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:voltican_fitness/models/meal.dart';

import 'package:voltican_fitness/widgets/button.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class TraineePlanDetailScreen extends StatefulWidget {
  const TraineePlanDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  State<TraineePlanDetailScreen> createState() => _TraineePlanDetailState();
}

class _TraineePlanDetailState extends State<TraineePlanDetailScreen> {
  double value = 3.8;

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
                Navigator.of(context).pop(); // Close the dialog
                // You can call a function here to delete the item
                // For example: _deleteItem();
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
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme: const IconThemeData(size: 28.0),
        backgroundColor: Colors.green[900],
        visible: true,
        curve: Curves.bounceInOut,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.check),
            backgroundColor: Colors.blue,
            label: 'Mark as Complete',
            onTap: () {},
          ),
        ],
      ),
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
                  Row(
                    children: [
                      RatingStars(
                        value: value,
                        onValueChanged: (v) {
                          setState(() {
                            value = v;
                          });
                        },
                        starCount: 5,
                        starSpacing: 2,
                        valueLabelVisibility: true,
                        maxValue: 5,
                        starOffColor: const Color(0xffe7e8ea),
                        starColor: Colors.yellow,
                      ),
                      const SizedBox(width: 10),
                      const Text("(32 Reviews)"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker \n"
                    "psum passages, and more recently with desk publishing software like Aldus PageMaker  .",
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(height: 20),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Private',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Ingredients',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 120,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Cucumber (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Cabbage (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Carrot (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const Text(
                    'Tomato (38 Cal)',
                    style: TextStyle(color: Colors.black38),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Instructions',
                    style: TextStyle(fontSize: 20),
                  ),
                  Container(
                    width: 120,
                    height: 3,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(20),
                    ),
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
                      _showDeleteConfirmationDialog(context);
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.red,
                        text: 'Submit Review',
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
