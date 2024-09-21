// ignore_for_file: use_build_context_synchronously, avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/edit_recipe_screen.dart';
import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/conversions/capitalize_first.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
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
  RecipeService recipeService = RecipeService();
  User? owner;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  @override
  void didChangeDependencies() {
    isFollowing = checkIfFollowing() ?? false;
    super.didChangeDependencies();
  }

  bool? checkIfFollowing() {
    final me = ref.read(userProvider);
    if (me == null) return null;

    final followingTrainersAsync = ref.watch(followingTrainersProvider(me.id));
    if (followingTrainersAsync.value == null) {
      return null;
    }

    return followingTrainersAsync.value
        ?.any((trainer) => trainer.id == widget.meal.createdBy);
  }

  void _fetchUser() async {
    try {
      await AuthService().getUser(
        userId: widget.meal.createdBy,
        onSuccess: (fetchedUser) {
          setState(() {
            owner = fetchedUser;
          });
        },
      );
      print('-----------------------print owner deatils---------------------');
      print(owner);
    } catch (e) {
      // Handle unexpected errors here
      showSnack(context, 'An unexpected error occurred');
    }
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Confirm Delete',
            style: TextStyle(color: Colors.black87),
          ),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete this item?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
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

  void _toggleFollow() async {
    // Update the follow status in the database
    final me = ref.read(userProvider);
    if (isFollowing) {
      await ref
          .read(followersProvider(
                  widget.meal.createdBy.isNotEmpty ? widget.meal.createdBy : '')
              .notifier)
          .unfollowTrainer(me!.id, widget.meal.createdBy);
    } else {
      await ref
          .read(followersProvider(
                  widget.meal.createdBy.isNotEmpty ? widget.meal.createdBy : '')
              .notifier)
          .followTrainer(me!.id, widget.meal.createdBy, context);
    }

    setState(() {
      isFollowing = !isFollowing;
    });

    // Show alert if the user is following
    NativeAlerts().showSuccessAlert(
      context,
      isFollowing
          ? 'You are now following the trainer'
          : 'You have unfollowed the trainer.',
    );
  }

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
                child: Center(
                  child: Container(
                    width: 30,
                    height: 5,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.black26,
                    ),
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
                child: const Icon(
                  Icons.arrow_back_outlined,
                  size: 30,
                  color: Colors.white,
                ),
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
                      CapitalizeFirstLetter(
                          text: widget.meal.title,
                          style: const TextStyle(
                              overflow: TextOverflow.ellipsis,
                              fontSize: 20,
                              fontWeight: FontWeight.w800)),
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
                                itemSize: 12,
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: owner != null &&
                                    owner!.imageUrl != null &&
                                    owner!.imageUrl!.isNotEmpty
                                ? NetworkImage(owner!.imageUrl!)
                                : const AssetImage(
                                    'assets/images/default_profile.png'),
                          ),

                          const SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                owner != null ? owner!.fullName : 'Loading...',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500),
                              ),
                              Text(
                                owner != null ? owner!.username : '',
                                style: const TextStyle(
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),

                          const Spacer(),
                          // Contact section goes here
                          user!.role != '0'
                              ? OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0, vertical: 8.0),
                                    minimumSize:
                                        const Size(80, 30), // width, height
                                  ),
                                  onPressed: _toggleFollow,
                                  child: Text(
                                    isFollowing ? 'Unfollow' : 'Follow',
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.redAccent),
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    widget.meal.description,
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
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
                        size: 20,
                        color: Colors.orange,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Ingredients',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: SizedBox(
                      // Adjust the height based on your needs
                      child: Column(
                        children: widget.meal.ingredients.map((ingredient) {
                          return Row(
                            children: [
                              const SizedBox(width: 8.0),
                              Text(
                                ingredient,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          );
                        }).toList(),
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.meal.instructions,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
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
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.meal.facts,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const SizedBox(height: 30),
                  user.role != '0'
                      ? InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    EditRecipeScreen(recipe: widget.meal)));
                          },
                          splashColor: Colors.purple,
                          child: const ButtonWidget(
                              backColor: Colors.redAccent,
                              text: 'Edit and Save',
                              textColor: Colors.white),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                  InkWell(
                    onTap: () async {
                      Navigator.of(context).pop();
                      await ref
                          .read(savedRecipesProvider.notifier)
                          .saveRecipe(user.id, widget.meal);
                      NativeAlerts().showSuccessAlert(
                          context, "Recipe saved successfully");
                    },
                    splashColor: Colors.purple,
                    child: const ButtonWidget(
                        backColor: Colors.redAccent,
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
