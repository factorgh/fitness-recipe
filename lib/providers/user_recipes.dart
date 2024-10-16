// provider.dart

// ignore_for_file: avoid_print

import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final RecipeService _recipeService = RecipeService();

// Provider to manage recipes by the user
final userRecipesProvider =
    StateNotifierProvider<UserRecipesNotifier, List<Recipe>>((ref) {
  return UserRecipesNotifier(_recipeService);
});

class UserRecipesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeService _recipeService;

  UserRecipesNotifier(this._recipeService) : super([]);

  Future<void> loadUserRecipes() async {
    try {
      final recipes = await _recipeService.fetchRecipesByUser();
      state = recipes;
    } catch (e) {
      // Handle errors if needed
      throw Exception('Error loading user recipes: $e');
    }
  }

  Future<void> createRecipe(Recipe recipe, BuildContext context) async {
    try {
      await _recipeService.createRecipe(context, recipe);

      // Add recipe if not already present
      if (!state.any((r) => r.id == recipe.id)) {
        state = [...state, recipe];
      }
    } catch (e) {
      print('Error saving recipe: $e');
    }
  }

  Future<void> updateRecipe(String recipeId, Recipe updatedRecipe) async {
    try {
      final updatedRecipeData = {
        'title': updatedRecipe.title,
        'description': updatedRecipe.description,
        'ingredients': updatedRecipe.ingredients,
        'instructions': updatedRecipe.instructions,
        'facts': updatedRecipe.facts,
        'imageUrl': updatedRecipe.imageUrl,
        'period': updatedRecipe.period,
      };

      await _recipeService.updateRecipe(recipeId, updatedRecipeData);
      state = state
          .map((recipe) => recipe.id == recipeId ? updatedRecipe : recipe)
          .toList();
    } catch (e) {
      print('Error updating recipe: $e');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _recipeService.deleteRecipe(recipeId);
      state = state.where((recipe) => recipe.id != recipeId).toList();
    } catch (e) {
      print('Error deleting recipe: $e');
    }
  }
}
