// conversion_utils.dart

// ignore_for_file: avoid_print

import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/utils/hive/hive_meal.dart';
import 'package:voltican_fitness/utils/hive/hive_recipe.dart';
import 'package:voltican_fitness/utils/hive/hive_recurrence.dart';

HiveRecurrence convertToHiveRecurrence(Recurrence recurrence) {
  print('----------------Recurrence in conversion----------------');
  print(recurrence);

  return HiveRecurrence(
      option: recurrence.option,
      date: recurrence.date,
      customDates: recurrence.customDates,
      exceptions: recurrence.exceptions,
      customDays: recurrence.customDays);
}

Recurrence convertFromHiveRecurrence(HiveRecurrence recurrence) {
  print('----------------Recurrence in conversion----------------');
  print(recurrence);

  return Recurrence(
      option: recurrence.option,
      date: recurrence.date,
      customDates: recurrence.customDates,
      exceptions: recurrence.exceptions,
      customDays: recurrence.customDays);
}

// Convert Recipes to Hive Recipe
List<HiveRecipe> convertRecipeToHiveRecipes(List<Recipe> recipes) {
  return recipes.map((recipe) {
    return HiveRecipe(
        id: recipe.id!,
        title: recipe.title,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        description: recipe.description,
        facts: recipe.facts,
        imageUrl: recipe.imageUrl,
        status: recipe.status,
        createdAt: recipe.createdAt,
        updatedAt: recipe.updatedAt,
        period: recipe.period,
        createdBy: recipe.createdBy);
  }).toList();
}

List<Recipe> convertHiveRecipeToRecipes(List<HiveRecipe> recipes) {
  return recipes.map((recipe) {
    return Recipe(
        id: recipe.id,
        title: recipe.title,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        description: recipe.description,
        facts: recipe.facts,
        imageUrl: recipe.imageUrl,
        status: recipe.status,
        createdAt: recipe.createdAt,
        updatedAt: recipe.updatedAt,
        period: recipe.period,
        createdBy: recipe.createdBy
        // Add more properties as needed
        // etc.
        );
  }).toList();
}

// Convert to Hive Meals
List<HiveMeal> convertMealsToHiveMeals(
    List<Meal> meals, Recurrence chosenRecurrence) {
  // Chosen recurrence
  print('---------------------chosen recurrence');
  print(chosenRecurrence);
  return meals.map((meal) {
    return HiveMeal(
        mealType: meal.mealType,
        recipes: convertRecipeToHiveRecipes(meal.recipes!),
        isDraft: true,
        timeOfDay: meal.timeOfDay,
        date: meal.date,
        recurrence: convertToHiveRecurrence(chosenRecurrence)
        // etc.
        );
  }).toList();
}

// Convert Meals from Hive back
List<Meal> convertHiveMealsToMeals(List<HiveMeal> meals) {
  return meals.map((meal) {
    return Meal(
        mealType: meal.mealType,
        recipes: convertHiveRecipeToRecipes(meal.recipes),
        isDraft: true,
        timeOfDay: meal.timeOfDay,
        date: meal.date!,
        recurrence: convertFromHiveRecurrence(meal.recurrence!)
        // etc.
        );
  }).toList();
}
