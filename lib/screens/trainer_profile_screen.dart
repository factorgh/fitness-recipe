// ignore_for_file: unused_result, use_build_context_synchronously, unused_element, avoid_print

import 'dart:core';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/trainer_provider.dart';
import 'package:fit_cibus/providers/user_provider.dart';
import 'package:fit_cibus/screens/trainer_meal_details_trainee.dart';
import 'package:fit_cibus/services/auth_service.dart';
import 'package:fit_cibus/services/email_service.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:fit_cibus/utils/native_alert.dart';
import 'package:fit_cibus/widgets/recipe_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
  User? user;
  final EmailService emailService = EmailService();

  final alerts = NativeAlerts();
  bool isLoading = false;
  bool isFollowing = false;
  bool sent = false;

  @override
  Widget build(BuildContext context) {
    final isMyFollowing = checkIfFollowing() ?? false;
    print(
        '----------------------------Value of is myFollowing-------------$isMyFollowing');

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
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: user == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent))
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
                                        'assets/images/default_profile.png')
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
                                fontSize: 18, fontWeight: FontWeight.w500),
                          ),
                          Text(
                            user!.email,
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 5),
                          Column(
                            children: [
                              if (me!.role == "1") ...[
                                _buildFollowButton(me,
                                    isMyFollowing), // Show Follow button if the user is a trainer
                              ] else if (me.role == "0") ...[
                                _buildRequestButton(me,
                                    isMyFollowing), // Show Request button if the user is a trainee
                              ],
                            ],
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
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  bool? checkIfFollowing() {
    final me = ref.read(userProvider);
    if (me == null) return null;

    final followingTrainersAsync = ref.watch(followingTrainersProvider(me.id));
    if (followingTrainersAsync.value == null || user == null) {
      return null;
    }

    return followingTrainersAsync.value
        ?.any((trainer) => trainer.id == user!.id);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      isFollowing = checkIfFollowing() ?? true;
    });

    print('isFollowing: $isFollowing');
  }

  @override
  void initState() {
    super.initState();
    _fetchUser();
    _fetchUserRecipes();
  }

  void selectMeal(BuildContext context, Recipe meal) {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => TrainerMealDetailScreen(meal: meal),
    ));
  }

  Widget _buildFollowButton(User me, bool isMyFollow) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        backgroundColor: Colors.redAccent,
        foregroundColor: Colors.white,
      ),
      onPressed: isLoading
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });

              try {
                if (isFollowing) {
                  // Show bottom sheet for unfollow confirmation
                  _showUnfollowConfirmationBottomSheet(
                    context,
                    () async {
                      await ref
                          .read(followersProvider(widget.userId).notifier)
                          .unfollowTrainer(me.id, widget.userId);
                      setState(() {
                        isFollowing = false;
                      });
                      ref.refresh(followingTrainersProvider(me.id));
                    },
                  );
                } else {
                  await ref
                      .read(followersProvider(widget.userId).notifier)
                      .followTrainer(me.id, widget.userId, context);
                  setState(() {
                    isFollowing = true;
                  });
                  ref.refresh(followingTrainersProvider(me.id));
                }
              } catch (error) {
                print("Error: $error");
              } finally {
                setState(() {
                  isLoading = false;
                });
              }
            },
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
              isFollowing ? 'Unfollow' : 'Follow',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
    );
  }

  // Button to handle "Request" feature for trainees
  Widget _buildRequestButton(User me, bool isFollowing) {
    return isFollowing
        ? const SizedBox.shrink()
        : ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            onPressed: isLoading
                ? null
                : () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      await emailService.sendEmail(user!.email, me.email);
                      alerts.showSuccessAlert(
                          context, "Request sent successfully");
                      setState(() {
                        sent = true;
                      });
                    } catch (error) {
                      print("Error: $error");
                      alerts.showErrorAlert(
                          context, "Request Not sent.Account is private");
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
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
                    sent ? "Request sent" : "Send a request",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
          );
  }

  void _fetchUser() {
    authService.getUser(
      userId: widget.userId,
      onSuccess: (fetchedUser) {
        setState(() {
          user = fetchedUser;
          isFollowing = checkIfFollowing() ?? false;
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
          userRecipes = recipes;
        });
      },
    );
  }

  void _handleFollowButtonPress() async {
    setState(() {
      isLoading = true;
    });

    try {
      final me = ref.read(userProvider);
      if (me == null) return;

      if (isFollowing) {
        _showUnfollowConfirmationBottomSheet(
          context,
          () async {
            await ref
                .read(followersProvider(widget.userId).notifier)
                .unfollowTrainer(me.id, widget.userId);
            setState(() {
              isFollowing = false;
            });
          },
        );
      } else {
        await ref
            .read(followersProvider(widget.userId).notifier)
            .followTrainer(me.id, widget.userId, context);
        setState(() {
          isFollowing = true;
        });
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showUnfollowConfirmationBottomSheet(
      BuildContext context, VoidCallback onConfirm) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Unfollow Trainer",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                "Are you sure you want to unfollow this trainer?",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      onConfirm();
                      setState(() {
                        isFollowing = false;
                      });
                      ref.refresh(followingTrainersProvider(
                          ref.read(userProvider)!.id));
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                    ),
                    child: const Text(
                      "Unfollow",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
