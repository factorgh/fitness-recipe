import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/widgets/meal_period_card.dart';
import 'package:intl/intl.dart';

class SingleMealPlanScreenTrainee extends ConsumerWidget {
  final MealPlan mealPlan;
  final DateTime selectedDay;

  const SingleMealPlanScreenTrainee({
    super.key,
    required this.mealPlan,
    required this.selectedDay,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = ref.watch(allRecipesProvider);

    // Filter meals for the selected day
    final selectedMeals = mealPlan.meals.where((meal) {
      return isSameDay(meal.date, selectedDay);
    }).toList();

    // Group recipes by period
    final Map<String, List<Map<String, dynamic>>> groupedMeals = {
      'Breakfast': [],
      'Lunch': [],
      'Snack': [],
      'Dinner': [],
    };

    // Match filtered meals with recipes and add meal type and time
    for (final meal in selectedMeals) {
      for (final recipeId in meal.recipes ?? []) {
        try {
          final recipe = allRecipes.firstWhere((r) => r.id == recipeId);
          groupedMeals[recipe.period]?.add({
            'recipe': recipe,
            'timeOfDay': meal.timeOfDay,
            'mealType': meal.mealType, // Add meal type
          });
        } catch (e) {
          print('Recipe with ID $recipeId not found. Error: $e');
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meal Details',
            style: TextStyle(fontWeight: FontWeight.w800)),
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
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
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

  Widget _buildAllocatedMeals(
      Map<String, List<Map<String, dynamic>>> groupedMeals) {
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
                    children: entry.value.map((mealInfo) {
                      final recipe = mealInfo['recipe'] as Recipe;
                      final timeOfDay = mealInfo['timeOfDay'] as String;

                      return MealPeriodCard(
                        recipe: recipe,
                        mealPeriod: recipe.title,
                        time1: timeOfDay,
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

  String _formatTime(DateTime time) {
    return time.hour > 12
        ? '${time.hour - 12}:${time.minute.toString().padLeft(2, '0')} PM'
        : '${time.hour}:${time.minute.toString().padLeft(2, '0')} AM';
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
}
