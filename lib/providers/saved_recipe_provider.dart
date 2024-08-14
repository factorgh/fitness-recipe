import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/recipe_service_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

class SavedRecipesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeService _recipeService;

  SavedRecipesNotifier(this._recipeService) : super([]);

  Future<void> saveRecipe(String userId, Recipe recipe) async {
    try {
      await _recipeService.saveRecipe(userId, recipe.id!);

      if (!state.any((r) => r.id == recipe.id)) {
        state = [...state, recipe];
      }
    } catch (e) {
      throw Exception('Error saving recipe: $e');
    }
  }

  Future<void> loadSavedRecipes(String userId) async {
    try {
      final recipes = await _recipeService.fetchSavedRecipes(userId);
      state = recipes;
    } catch (e) {
      throw Exception('Error loading saved recipes: $e');
    }
  }

  Future<void> loadUserRecipes() async {
    try {
      final recipes = await _recipeService.fetchRecipesByUser();
      state = recipes;
    } catch (e) {
      throw Exception('Error loading user recipes: $e');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await _recipeService.deleteRecipe(recipeId);
      state = state.where((recipe) => recipe.id != recipeId).toList();
    } catch (e) {
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
        // Include 'period' and 'createdBy' if necessary
      };

      await _recipeService.updateRecipe(recipeId, updatedRecipeData);
      state = state
          .map((recipe) => recipe.id == recipeId ? updatedRecipe : recipe)
          .toList();
    } catch (e) {
      throw Exception('Error updating recipe: $e');
    }
  }
}

// Provider for saved recipes
final savedRecipesProvider =
    StateNotifierProvider<SavedRecipesNotifier, List<Recipe>>((ref) {
  return SavedRecipesNotifier(ref.read(recipeServiceProvider));
});
