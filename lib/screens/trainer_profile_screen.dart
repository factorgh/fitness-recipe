// ignore_for_file: avoid_print

import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';

import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/top_trainer_details.dart';

import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/native_alert.dart';

import 'package:voltican_fitness/widgets/top_trainer_item.dart';

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
  List<Map<String, dynamic>> userRecipes = [];
  RecipeService recipeService = RecipeService();
  List<String> _ownerImage = [];
  List<String> _ownerEmail = [];
  List<String> _ownerUsername = [];
  List<String> _ownerIds = [];
  final alerts = NativeAlerts();

  @override
  void initState() {
    super.initState();
    _fetchUserRecipes();
  }

  void _fetchUserRecipes() {
    recipeService.getRecipesByUser(
      userId: widget.userId,
      context: context,
      onSuccess: (recipes) {
        setState(() {
          _ownerImage = recipes
              .map((recipe) =>
                  recipe['createdBy']['imageUrl'] as String? ??
                  'https://cdn.pixabay.com/photo/2018/11/13/21/43/avatar-3814049_1280.png')
              .toList();
          _ownerUsername = recipes
              .map((recipe) => recipe['createdBy']['username'] as String)
              .toList();
          _ownerIds = recipes
              .map((recipe) => recipe['createdBy']['_id'] as String)
              .toList();
          _ownerEmail = recipes
              .map((recipe) => recipe['createdBy']['email'] as String)
              .toList();
          userRecipes =
              recipes.map((recipe) => recipe as Map<String, dynamic>).toList();
        });
      },
    );
  }

  void selectMeal(BuildContext context, Map<String, dynamic> meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TopTrainerDetailsScreen(meal: meal),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.read(userProvider);
    final followersNotifier = ref.read(
        followersProvider(_ownerIds.isNotEmpty ? _ownerIds[0] : '').notifier);

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
      body: _ownerImage.isNotEmpty &&
              _ownerUsername.isNotEmpty &&
              _ownerEmail.isNotEmpty
          ? Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundImage:
                            CachedNetworkImageProvider(_ownerImage[0]),
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            _ownerUsername[0],
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            _ownerEmail[0],
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          user!.role == "1"
                              ? ElevatedButton(
                                  onPressed: () {
                                    followersNotifier.followTrainer(
                                        user.id, _ownerIds[0], context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.greenAccent[50],
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Follow',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    print('Request button pressed');
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.lightBlue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text(
                                    'Send a request',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
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
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: userRecipes.length,
                    itemBuilder: (context, index) => TrainerRecipeItem(
                      recipe: userRecipes[index],
                      selectMeal: (recipe) {
                        selectMeal(context, recipe);
                      },
                    ),
                  ),
                ),
              ],
            )
          : const Center(
              child: Text(
                'No recipes found for this trainer.',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            ),
    );
  }
}
