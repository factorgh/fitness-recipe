// ignore_for_file: use_build_context_synchronously, unused_element, avoid_print

import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/saved_recipe_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:fit_cibus/utils/conversions/capitalize_first.dart';
import 'package:fit_cibus/utils/show_image_util.dart';
import 'package:fit_cibus/utils/show_snackbar.dart';
import 'package:fit_cibus/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TrainerMealDetailScreen extends ConsumerStatefulWidget {
  final Recipe meal;
  const TrainerMealDetailScreen({super.key, required this.meal});

  @override
  ConsumerState<TrainerMealDetailScreen> createState() =>
      _TrainerMealDetailScreenState();
}

class _TrainerMealDetailScreenState
    extends ConsumerState<TrainerMealDetailScreen> {
  double value = 0.0;
  bool isPrivate = false;
  bool isFollowing = false;
  final AuthService authService = AuthService();
  User? user;
  User? trainer;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
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
                    top: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        TextButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            elevation: 0,
                            shape: const CircleBorder(),
                          ),
                          onPressed: () {
                            ShowImageUtil.showImagePreview(
                                context, widget.meal.imageUrl);
                          },
                          child: const Icon(
                            Icons.visibility_outlined,
                            color: Colors.white,
                            size: 30,
                          ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CapitalizeFirstLetter(
                        text: widget.meal.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
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
                                initialRating: value,
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
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Recipe by",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: trainer != null &&
                                    trainer!.imageUrl != null &&
                                    trainer!.imageUrl!.isNotEmpty
                                ? NetworkImage(trainer!.imageUrl!)
                                : const AssetImage(
                                    'assets/images/default_profile.png'),
                          ),

                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                trainer != null
                                    ? trainer!.fullName
                                    : 'Loading...',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                trainer != null ? trainer!.username : '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),

                          const Spacer(),
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
                      Navigator.of(context).pop();
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
                  const SizedBox(height: 10),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() {
    authService.getUser(
      userId: widget.meal.createdBy,
      onSuccess: (fetchedUser) {
        setState(() {
          trainer = fetchedUser;
        });
      },
    );
    print('------------------------User fetched------------------------');
    print(trainer);
  }

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
}
