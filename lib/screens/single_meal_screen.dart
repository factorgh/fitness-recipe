// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';

import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/screens/meal_update_screen.dart';
import 'package:voltican_fitness/widgets/meal_period_card.dart';
import 'package:intl/intl.dart';

class SingleMealPlanDetailScreen extends ConsumerWidget {
  final MealPlan mealPlan;

  const SingleMealPlanDetailScreen({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = ref.watch(allRecipesProvider);
    final traineeDetailsAsyncValue =
        ref.watch(traineeDetailsProvider(mealPlan.trainees));

    // Group recipes by period
    final Map<String, List<Meal>> groupedMeals = {
      'Breakfast': [],
      'Lunch': [],
      'Snack': [],
      'Dinner': [],
    };

    for (final allocation in mealPlan.meals) {
      try {
        final meal = allRecipes
            .where((recipe) => allocation.recipes.contains(recipe))
            .map((recipe) => Meal(
                  date: DateTime.now(),
                  mealType: recipe.period,
                  recipes: [recipe],
                  allocatedTime: allocation.allocatedTime,
                ))
            .toList();

        for (var meal in meal) {
          groupedMeals[meal.mealType]?.add(meal);
        }
      } catch (e) {
        // Handle cases where the recipe is not found
        print(
            'Error processing allocation with ID ${allocation.recipes}. Error: $e');
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Meal Plan Details',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildDetailCard("Meal Plan Name", mealPlan.name),
            _buildDetailCard("Duration Selected", mealPlan.duration),
            _buildDateRange(mealPlan.startDate, mealPlan.endDate),
            _buildAllocatedMeals(groupedMeals),
            _buildTraineeCard(context, traineeDetailsAsyncValue),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MealUpdateScreen(mealPlan: mealPlan)));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Update',
                style: TextStyle(fontSize: 18),
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

  // Widget _buildDaysForMeal() {
  //   if (mealPlan.days.isNotEmpty) {
  //     // Join all the days with a comma to display them in a single line
  //     String daysText = mealPlan.days.join(', ');

  //     return Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Card(
  //           elevation: 2,
  //           child: Padding(
  //             padding: const EdgeInsets.all(8.0),
  //             child: Text(
  //               daysText,
  //               style: const TextStyle(color: Colors.black45, fontSize: 16),
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //       ],
  //     );
  //   }

  //   return _buildDetailCard("", "Repeats Everyday");
  // }

  Widget _buildAllocatedMeals(Map<String, List<Meal>> groupedMeals) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: groupedMeals.entries.map((entry) {
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
                    children: entry.value.map((meal) {
                      return Column(
                        children: meal.recipes.map((recipe) {
                          return MealPeriodCard(
                            mealPeriod: entry.key,
                            time1: _formatTime(meal.allocatedTime),
                            time2: '', // Add other time logic if needed
                            image: recipe.imageUrl, // Adjust with your images
                          );
                        }).toList(),
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

  String _formatTime(DateTime time) {
    return time.hour >= 12
        ? '${time.hour > 12 ? time.hour - 12 : time.hour}:${time.minute.toString().padLeft(2, '0')} PM'
        : '${time.hour}:${time.minute.toString().padLeft(2, '0')} AM';
  }
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
