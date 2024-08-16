import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/all_recipes_provider.dart';
import 'package:voltican_fitness/widgets/meal_period_card.dart';

class SingleMealPlanDetailScreen extends ConsumerWidget {
  final MealPlan mealPlan;

  const SingleMealPlanDetailScreen({super.key, required this.mealPlan});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allRecipes = ref.watch(allRecipesProvider);

    // Group recipes by period
    final Map<String, List<Recipe>> groupedRecipes = {
      'Breakfast': [],
      'Lunch': [],
      'Snack': [],
      'Dinner': [],
    };

    for (final allocation in mealPlan.recipeAllocations) {
      final recipe = allRecipes.firstWhere(
        (recipe) => recipe.id == allocation.recipeId,
      );
      groupedRecipes[recipe.period]?.add(recipe);
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
            _buildDaysForMeal(),
            _buildAllocatedMeals(groupedRecipes),
            ElevatedButton(
              onPressed: () {
                _showUpdateBottomSheet(context);
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

  Widget _buildDaysForMeal() {
    if (mealPlan.duration == 'Custom') {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Days for Meal",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: mealPlan.days.map((day) {
              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    day,
                    style: const TextStyle(color: Colors.black45),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),
        ],
      );
    } else {
      return _buildDetailCard("Days for Meal", "Repeats Everyday");
    }
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
                      final allocation = mealPlan.recipeAllocations.firstWhere(
                          (allocation) => allocation.recipeId == recipe.id);

                      return MealPeriodCard(
                        mealPeriod: recipe.title,
                        time1: _formatTime(allocation.allocatedTime),
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

  void _showUpdateBottomSheet(BuildContext context) {
    // Implementation of update bottom sheet...
  }
}
