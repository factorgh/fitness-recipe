import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:voltican_fitness/models/meal.dart';

class TraineePlanDetailScreen extends StatefulWidget {
  const TraineePlanDetailScreen({super.key, required this.meal});
  final Meal meal;

  @override
  State<TraineePlanDetailScreen> createState() => _TraineePlanDetailState();
}

class _TraineePlanDetailState extends State<TraineePlanDetailScreen> {
  double value = 3.8;

  Future<void> _showReviewConfirmationDialog(BuildContext context) async {
    final TextEditingController reviewController = TextEditingController();

    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to dismiss
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Text(
            'Submit Your Review',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                const Text(
                  'Please enter your review below:',
                  style: TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: reviewController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: 'Enter your review here',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actionsPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.redAccent,
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Skip'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              ),
              child: const Text('Submit'),
              onPressed: () {
                // Handle the submit action
                String review = reviewController.text;
                if (review.isNotEmpty) {
                  // Perform the submit action
                  // For example, you can call a function to handle the review submission
                  // _submitReview(review);
                  print("Review submitted: $review");
                }
                Navigator.of(context).pop(); // Close the dialog
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
                          _showReviewConfirmationDialog(
                              context); // Show dialog on rating change
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
                    "Lorem ipsum passages, and more recently with desk publishing software like Aldus PageMaker.",
                    style: TextStyle(color: Colors.black38),
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
