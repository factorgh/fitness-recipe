// ignore_for_file: avoid_print

import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/providers/recipe_service_provider.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// StateNotifier for managing saved recipes
class SavedRecipesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeService _recipeService;

  SavedRecipesNotifier(this._recipeService) : super([]);

  Future<void> saveRecipe(String userId, Recipe recipe) async {
    try {
      await _recipeService.saveRecipe(userId, recipe.id!);

      // Add recipe if not already present
      if (!state.any((r) => r.id == recipe.id)) {
        state = [...state, recipe];
      }
    } catch (e) {
      print('Error saving recipe: $e');
    }
  }

  Future<void> loadSavedRecipes(String userId) async {
    try {
      final recipes = await _recipeService.fetchSavedRecipes(userId);
      state = recipes;
    } catch (e) {
      print('Error loading saved recipes: $e');
      state = []; // Clear state or provide a fallback
    }
  }

  Future<void> removeSavedRecipe(String userId, String recipeId) async {
    try {
      final success = await _recipeService.removeSavedRecipe(userId, recipeId);
      if (success) {
        state = state.where((recipe) => recipe.id != recipeId).toList();
      }
    } catch (e) {
      print('Error removing saved recipe: $e');
    }
  }
}

// StateNotifier for managing user recipes

// Providers for recipes
final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, List<Recipe>>((ref) {
  return SavedRecipesNotifier(ref.read(recipeServiceProvider));
});
