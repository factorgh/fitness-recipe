// ignore_for_file: avoid_print

import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';

import 'package:voltican_fitness/screens/trainer_meal_details_trainee.dart';

import 'package:voltican_fitness/services/auth_service.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/native_alert.dart';
import 'package:voltican_fitness/widgets/recipe_item.dart';

class TrainerProfileScreen extends ConsumerStatefulWidget {
  final String userId;

  const TrainerProfileScreen({
    required this.userId,
    super.key,
  });

  @override
  ConsumerState<TrainerProfileScreen> createState() =>
      _TrainerProfileScreenState();
}

class _TrainerProfileScreenState extends ConsumerState<TrainerProfileScreen> {
  List<Recipe> userRecipes = [];
  final RecipeService recipeService = RecipeService();
  final AuthService authService = AuthService();
  User? user; // Allow user to be null

  final alerts = NativeAlerts();
  bool isLoading = false; // Add a loading state variable

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchUserRecipes();
  }

  void _fetchUser() {
    authService.getUser(
      userId: widget.userId,
      onSuccess: (fetchedUser) {
        setState(() {
          user = fetchedUser;
        });
      },
    );
  }

  void _fetchUserRecipes() {
    recipeService.getRecipesByUser(
      userId: widget.userId,
      context: context,
      onSuccess: (recipes) {
        setState(() {
          userRecipes = recipes.map((recipe) => recipe).toList();
        });
      },
    );
  }

  void selectMeal(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainerMealDetailScreen(meal: meal),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final followersNotifier = ref.watch(
        followersProvider(widget.userId.isNotEmpty ? widget.userId : '')
            .notifier);

    final me = ref.read(userProvider);
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Trainer Profile',
          style: TextStyle(fontWeight: FontWeight.w800),
        ),
      ),
      body: user == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            user!.imageUrl != null && user!.imageUrl!.isNotEmpty
                                ? CachedNetworkImageProvider(user!.imageUrl!)
                                : const AssetImage(
                                        'assets/images/default_avatar.png')
                                    as ImageProvider,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            user!.fullName,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            user!.email,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () async {
                                    setState(() {
                                      isLoading = true;
                                    });

                                    if (me?.role == "1") {
                                      // Handle follow action
                                      await followersNotifier.followTrainer(
                                          me!.id, widget.userId, context);
                                    } else if (me!.role == "0") {
                                      // Handle send request action
                                      alerts.showSuccessAlert(
                                          context, "Request sent successfully");
                                      print('Request button pressed');
                                    }

                                    setState(() {
                                      isLoading = false;
                                    });
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: me?.role == "1"
                                  ? Colors.greenAccent[50]
                                  : Colors.lightBlue,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.0,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    me?.role == "1"
                                        ? 'Follow'
                                        : 'Send a request',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: me?.role == "1"
                                          ? Colors.black
                                          : Colors.white,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: Colors.black54, height: 10),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: userRecipes.isNotEmpty
                      ? ListView.builder(
                          padding: const EdgeInsets.all(8.0),
                          itemCount: userRecipes.length,
                          itemBuilder: (context, index) => RecipeItem(
                            meal: userRecipes[index],
                            selectMeal: (meal) {
                              selectMeal(context, meal);
                            },
                          ),
                        )
                      : const Center(
                          child: Text(
                            'No recipes found for this trainer.',
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                        ),
                ),
              ],
            ),
    );
  }
}
