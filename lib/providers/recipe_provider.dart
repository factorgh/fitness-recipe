import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, List<Recipe>>((ref) {
  return SavedRecipesNotifier();
});

class SavedRecipesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeService _recipeService = RecipeService();

  SavedRecipesNotifier() : super([]);

  Future<void> saveRecipe(String userId, Recipe recipe) async {
    // Save the recipe using the service
    await _recipeService.saveRecipe(userId, recipe.id!);

    // If the recipe is not already in the state, add it
    if (!state.any((r) => r.id == recipe.id)) {
      state = [...state, recipe];
    }
  }

  Future<void> loadSavedRecipes(String userId) async {
    // Fetch saved recipes
    final recipes = await _recipeService.fetchSavedRecipes(userId);

    // Update state with the fetched recipes
    state = recipes;
  }

  Future<void> loadUserRecipes() async {
    final recipes = await _recipeService.fetchRecipesByUser();
    state = recipes;
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _recipeService.deleteRecipe(recipeId);

      // Remove the recipe from the state
      state = state.where((recipe) => recipe.id != recipeId).toList();
    } catch (e) {
      // Handle errors if needed
      throw Exception('Error deleting recipe: $e');
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
      };
      await _recipeService.updateRecipe(
        recipeId,
        updatedRecipeData,
      );
      state = updatedRecipe as List<Recipe>;
    } catch (e) {
      throw Exception('Error updating recipe: $e');
    }
  }
}
