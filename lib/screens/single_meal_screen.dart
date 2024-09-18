// ignore_for_file: avoid_print, unused_element

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/screens/meal_update_screen.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';

class SingleMealPlanDetailScreen extends ConsumerWidget {
  final MealPlan mealPlan;

  SingleMealPlanDetailScreen({super.key, required this.mealPlan});

  final RecipeService recipeService = RecipeService();

  Future<List<Recipe>> fetchRecipes(List<String> recipeIds) async {
    try {
      final recipes = await Future.wait(
          recipeIds.map((id) => recipeService.getRecipeById(id)));
      return recipes.where((recipe) => recipe != null).cast<Recipe>().toList();
    } catch (e) {
      print('Error fetching recipes: $e');
      rethrow;
    }
  }

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
      final meal = allRecipes
          .where((recipe) => allocation.recipes!.contains(recipe.id))
          .map((recipe) => Meal(
                date: DateTime.now(),
                mealType: recipe.period,
                recipes: [recipe.id!],
                timeOfDay: allocation.timeOfDay,
              ))
          .toList();

      for (var mealItem in meal) {
        groupedMeals[mealItem.mealType]?.add(mealItem);
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
            const Text('Meal Allocations'),
            _buildMealFromDraft(mealPlan.meals),
            _buildTraineeCard(context, traineeDetailsAsyncValue),
            const SizedBox(height: 30),
            Reusablebutton(
              text: "Update",
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        MealUpdateScreen(mealPlan: mealPlan)));
              },
            )
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
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
              fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildMealFromDraft(List<Meal> convertedMeals) {
    if (convertedMeals.isEmpty) {
      return const Center(child: Text('No meals available.'));
    }

    // Group meals by date
    final Map<String, List<Meal>> groupedMeals = {};
    for (final meal in convertedMeals) {
      final formattedDate = DateFormat('yyyy-MM-dd').format(meal.date);
      if (groupedMeals.containsKey(formattedDate)) {
        groupedMeals[formattedDate]!.add(meal);
      } else {
        groupedMeals[formattedDate] = [meal];
      }
    }

    return SizedBox(
      height: 300, // Adjust the height as needed
      child: ListView(
        children: groupedMeals.entries.map((entry) {
          final date = entry.key;
          final meals = entry.value;

          return ExpansionTile(
            title: Text(date),
            children: meals.map((meal) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    title: Row(
                      children: [
                        Text(
                          meal.mealType,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Icon(Icons.arrow_circle_right),
                        ),
                        Text(meal.timeOfDay)
                      ],
                    ),
                  ),
                  FutureBuilder<List<Recipe>>(
                    future: fetchRecipes(meal.recipes!),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Recipe>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        return Column(
                          children: snapshot.data!
                              .map((recipe) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        backgroundImage:
                                            NetworkImage(recipe.imageUrl),
                                        backgroundColor: Colors.transparent,
                                      ),
                                      title: Text(recipe.title),
                                    ),
                                  ))
                              .toList(),
                        );
                      } else {
                        return const Text('No recipes available.');
                      }
                    },
                  ),
                ],
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
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
            Reusablebutton(
                text: 'Close',
                onPressed: () {
                  Navigator.pop(context);
                })
          ],
        ),
      );
    },
  );
}
