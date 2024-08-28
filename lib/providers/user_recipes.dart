import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

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
}
