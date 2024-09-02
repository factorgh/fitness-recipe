// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/utils/sqflite_setup/database_helpers.dart';
import 'package:voltican_fitness/widgets/meal_period_card.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';

void showMealPlanPreviewBottomSheet(
    BuildContext context, Function createPlan) async {
  final mealPlan = await DatabaseHelper().getFirstMealPlan();
  print('----------------------meal plan from the db$mealPlan');

  if (mealPlan == null) {
    // Handle the case where no meal plan is found
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('No meal plans available')),
    );
    return;
  }

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return MealPlanPreviewBottomSheet(
        mealPlan: mealPlan,
        createPlan: createPlan,
      );
    },
  );
}

class MealPlanPreviewBottomSheet extends ConsumerWidget {
  final MealPlan mealPlan;
  final Function createPlan;

  const MealPlanPreviewBottomSheet(
      {super.key, required this.mealPlan, required this.createPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = ref.watch(allRecipesProvider);
    final traineeDetailsAsyncValue =
        ref.watch(traineeDetailsProvider(mealPlan.trainees));

    // Group recipes by period
    final Map<String, List<Recipe>> groupedRecipes = {
      'Breakfast': [],
      'Lunch': [],
      'Snack': [],
      'Dinner': [],
    };

    for (final allocation in mealPlan.meals) {
      for (final recipeId in allocation.recipes) {
        try {
          final recipe = allRecipes.firstWhere(
            (recipe) => recipe.id == recipeId,
          );
          // Ensure the period exists in groupedRecipes
          groupedRecipes[recipe.period]?.add(recipe);
        } catch (e) {
          print('Recipe with ID $recipeId not found. Error: $e');
        }
      }
    }

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                            const Expanded(
                              child: Center(
                                child: Text(
                                  'Meal Plan Preview',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetailCard("Meal Plan Name", mealPlan.name),
                        _buildDetailCard(
                            "Duration Selected", mealPlan.duration),
                        _buildDateRange(mealPlan.startDate, mealPlan.endDate),
                        _buildAllocatedMeals(groupedRecipes),
                        _buildTraineeCard(context, traineeDetailsAsyncValue),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              onPressed: () {
                                createPlan();
                                Navigator.pop(context);
                              },
                              child: const Text('Create plan')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTraineeCard(
      BuildContext context, AsyncValue<List<User>> traineeDetailsAsyncValue) {
    return traineeDetailsAsyncValue.when(
      data: (trainees) {
        // Limit to first 3 trainees and show "and X others"
        final displayedTrainees = trainees.take(3).toList();
        final remainingCount = trainees.length - 3;

        return Card(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text(
                      'Trainees',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () {
                        _showTraineeList(context, trainees);
                      },
                      child: const Text('View All'),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Create a horizontal ListView for trainee images
                SizedBox(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                        displayedTrainees.length + (remainingCount > 0 ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index < displayedTrainees.length) {
                        final trainee = displayedTrainees[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: CircleAvatar(
                            backgroundImage: trainee.imageUrl != null
                                ? NetworkImage(trainee.imageUrl!)
                                : const AssetImage(
                                        'assets/images/default_profile.png')
                                    as ImageProvider,
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: Text('and $remainingCount others'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Text('Error loading trainees'),
    );
  }

  void _showTraineeList(BuildContext context, List<User> trainees) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Trainee List',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: trainees.length,
                  itemBuilder: (context, index) {
                    final trainee = trainees[index];
                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: trainee.imageUrl != null
                              ? NetworkImage(trainee.imageUrl!)
                              : const AssetImage(
                                      'assets/images/default_profile.png')
                                  as ImageProvider,
                        ),
                        title: Text(trainee.username),
                      ),
                    );
                  },
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDateRange(DateTime? startDate, DateTime? endDate) {
    if (startDate == null || endDate == null) {
      return const SizedBox.shrink();
    }

    String formattedStartDate = _formatDate(startDate);
    String formattedEndDate = _formatDate(endDate);

    return _buildDetailCard(
      "Meal Plan Duration",
      '$formattedStartDate - $formattedEndDate',
    );
  }

  String _formatDate(DateTime date) {
    String daySuffix(int day) {
      if (day >= 11 && day <= 13) {
        return 'th';
      }
      switch (day % 10) {
        case 1:
          return 'st';
        case 2:
          return 'nd';
        case 3:
          return 'rd';
        default:
          return 'th';
      }
    }

    String day = date.day.toString();
    String month = DateFormat('MMMM').format(date);
    String year = date.year.toString();

    return '$day${daySuffix(date.day)} $month, $year';
  }

  Widget _buildAllocatedMeals(Map<String, List<Recipe>> groupedRecipes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedRecipes.entries.map((entry) {
        return entry.value.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[700],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Column(
                    children: entry.value.map((recipe) {
                      final allocation = mealPlan.meals.firstWhere(
                          (allocation) => allocation.recipes.contains(recipe));

                      return MealPeriodCard(
                        mealPeriod: recipe.title,
                        time1: allocation.timeOfDay,
                        time2: '', // Add other time logic if needed
                        image: recipe.imageUrl, // Adjust with your images
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                ],
              )
            : const SizedBox.shrink();
      }).toList(),
    );
  }

  // String _formatTime(DateTime time) {
  //   return time.hour > 12
  //       ? '${time.hour - 12}:${time.minute.toString().padLeft(2, '0')} PM'
  //       : '${time.hour}:${time.minute.toString().padLeft(2, '0')} AM';
  // }
}
