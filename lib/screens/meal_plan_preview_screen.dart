// ignore_for_file: avoid_print, use_build_context_synchronously, unrelated_type_equality_checks, unused_element

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';
import 'package:voltican_fitness/utils/conversions/hive_conversions.dart';
import 'package:voltican_fitness/utils/hive/hive_class.dart';

import 'package:voltican_fitness/widgets/meal_period_card.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/widgets/reusable_button.dart';

void showMealPlanPreviewBottomSheet(
    BuildContext context, MealPlan mealplan) async {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return MealPlanPreviewBottomSheet(
        mealPlan: mealplan,
      );
    },
  );
}

class MealPlanPreviewBottomSheet extends ConsumerStatefulWidget {
  final MealPlan mealPlan;

  const MealPlanPreviewBottomSheet({
    super.key,
    required this.mealPlan,
  });

  @override
  ConsumerState<MealPlanPreviewBottomSheet> createState() =>
      _MealPlanPreviewBottomSheetState();
}

class _MealPlanPreviewBottomSheetState
    extends ConsumerState<MealPlanPreviewBottomSheet> {
  HiveService hiveService = HiveService();
  List<Meal> transMeal = <Meal>[];
  MealPlanService mealPlanService = MealPlanService();
  bool _isLoading = false;

  final RecipeService recipeService = RecipeService();
  @override
  void initState() {
    getHiveMeals();
    super.initState();
  }

  // Fetch meal from hive mealdraftbox
  Future<void> getHiveMeals() async {
    final meals = await hiveService.fetchAllMeals();
    print('---------------------------Meal from hive----------------------');
    print(meals);
    print(meals.length);

    // Convert hive meals to meals itself
    final convMeal = convertHiveMealsToMeals(meals);
    // Convert hive recurrences to recurrences

    print('-------------------------Converted meals --------------------');
    print(convMeal);
    setState(() {
      transMeal = convMeal;
    });
  }

  Future<void> _handleCreatePlan() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Read the user from the provider
      final user = ref.read(userProvider);

      // Check if the user is null
      if (user == null) {
        print('User is null. Cannot create a meal plan.');
        // Show an error dialog or navigate back
        // Optionally use a SnackBar or Dialog to inform the user
        showErrorDialog(
            'User not logged in. Please log in to create a meal plan.');
        return;
      }

      // Check if widget.mealPlan is null or has any required fields missing
      final mealPlan = widget.mealPlan;
      if (mealPlan.startDate == null ||
          mealPlan.endDate == null ||
          mealPlan.trainees.isEmpty ||
          transMeal.isEmpty) {
        print('Meal plan properties are missing or null.');
        // Show an error dialog or navigate back
        showErrorDialog('Meal plan details are incomplete.');
        return;
      }

      // Create a new meal plan
      final newMealPlan = MealPlan(
        name: mealPlan.name,
        startDate: mealPlan.startDate,
        endDate: mealPlan.endDate,
        duration: mealPlan.duration,
        trainees: mealPlan.trainees,
        meals: transMeal,
        createdBy: user.id,
      );

      print(
          '---------------------------------Meal plan body to db---------------');
      print(newMealPlan);
      print('------------------------end of meal plan body-------------------');

      // Save the meal plan to the database
      await mealPlanService.createMealPlan(newMealPlan, context);

      // Clear the meal draft box
      await hiveService.clearMealDraftBox();

      // Navigate back to the meal plan list
      Navigator.of(context).popUntil((route) => route.isFirst);
    } catch (e) {
      if (e is DioException) {
        print('DioException occurred: ${e.message}');
        if (e.response != null) {
          print('Response data: ${e.response?.data}');
          print('Response status code: ${e.response?.statusCode}');
        }
      } else {
        print('Error creating meal plan: ${e.toString()}');
      }
      // Show an error dialog or SnackBar
      showErrorDialog('An error occurred while creating the meal plan.');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Recipe?> fetchRecipe(String recipeId) async {
    try {
      final recipe = await recipeService.getRecipeById(recipeId);
      if (recipe != null) {
        return recipe;
      } else {
        print('Recipe with ID $recipeId not found');
        return null;
      }
    } catch (e) {
      print('Error fetching recipe with ID $recipeId: $e');
      return null;
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final allRecipes = ref.watch(allRecipesProvider);
    final traineeDetailsAsyncValue =
        ref.watch(traineeDetailsProvider(widget.mealPlan.trainees));

    // Group recipes by period
    final Map<String, List<Recipe>> groupedRecipes = {
      'Breakfast': [],
      'Lunch': [],
      'Snack': [],
      'Dinner': [],
    };

    for (final allocation in widget.mealPlan.meals) {
      for (final recipeId in allocation.recipes!) {
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
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildDetailCard(
                            "Meal Plan Name", widget.mealPlan.name),
                        const SizedBox(height: 15),
                        _buildDetailCard(
                            "Duration Selected", widget.mealPlan.duration),
                        const SizedBox(height: 15),
                        _buildDateRange(
                            widget.mealPlan.startDate, widget.mealPlan.endDate),
                        const Text(
                          'Meal Recurrence Set',
                          style: TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                        _buildMealFromDraft(transMeal),
                        const SizedBox(height: 15),
                        // _buildAllocatedMeals(groupedRecipes),
                        _buildTraineeCard(context, traineeDetailsAsyncValue),
                        const SizedBox(height: 30),
                        _isLoading
                            ? const Center(
                                child: CircularProgressIndicator(
                                    color: Colors.redAccent),
                              )
                            : SizedBox(
                                width: double.infinity,
                                child: Reusablebutton(
                                  text: 'Complete Plan',
                                  onPressed: _isLoading
                                      ? null
                                      : () async {
                                          await _handleCreatePlan();
                                        },
                                ),
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
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          foregroundColor: Colors.white),
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
      loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.redAccent)),
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

  Widget _buildMealFromDraft(List<Meal> convertedMeals) {
    if (convertedMeals.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(
            child: Text('No meals available.',
                style: TextStyle(fontWeight: FontWeight.w600))),
      );
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
                  // Fetch recipes asynchronously
                  FutureBuilder<List<Recipe>>(
                    future: _fetchRecipes(meal.recipes!),
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Recipe>> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (snapshot.hasData) {
                        final recipes = snapshot.data ?? [];
                        return Column(
                          children: recipes
                              .map((recipe) => Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: ListTile(
                                      leading: CircleAvatar(
                                        // ignore: unnecessary_null_comparison
                                        backgroundImage: recipe.imageUrl != null
                                            ? NetworkImage(recipe.imageUrl)
                                            : const AssetImage(
                                                    'assets/images/default_recipe.png')
                                                as ImageProvider,
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
                  )
                ],
              );
            }).toList(),
          );
        }).toList(),
      ),
    );
  }

  Future<List<Recipe>> _fetchRecipes(List<String> recipeIds) async {
    final List<Recipe> recipes = [];
    for (String id in recipeIds) {
      try {
        final recipe = await fetchRecipe(id);
        if (recipe != null) {
          recipes.add(recipe);
        }
      } catch (e) {
        print('Failed to fetch recipe $id: $e');
      }
    }
    return recipes;
  }

  Widget _buildDetailCard(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 10),
        Text(
          value,
          style: const TextStyle(
              fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
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
                      final allocation = widget.mealPlan.meals.firstWhere(
                          (allocation) =>
                              allocation.recipes!.contains(recipe.id));

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
}
