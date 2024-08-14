import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/recipe_service_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

class AllRecipesNotifier extends StateNotifier<List<Recipe>> {
  final RecipeService _recipeService;

  AllRecipesNotifier(this._recipeService) : super([]);

  Future<void> loadAllRecipes(BuildContext context) async {
    try {
      final recipes = await _recipeService.fetchAllRecipes(context);
      state = recipes;
    } catch (e) {
      state = []; // Set an empty list or handle the error as needed
    }
  }
}

// Provider for all recipes
final allRecipesProvider =
    StateNotifierProvider<AllRecipesNotifier, List<Recipe>>(
  (ref) => AllRecipesNotifier(ref.read(recipeServiceProvider)),
);