import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/providers/recipe_service_provider.dart';
import 'package:fit_cibus/services/recipe_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FollowedUsersRecipesNotifier
    extends StateNotifier<AsyncValue<List<Recipe>>> {
  final RecipeService _recipeService;
  final String _userId;

  FollowedUsersRecipesNotifier(this._recipeService, this._userId)
      : super(const AsyncValue.loading()) {
    fetchRecipes();
  }

  Future<void> fetchRecipes() async {
    try {
      final recipes = await _recipeService.fetchFollowedUsersRecipes(_userId);
      state = AsyncValue.data(recipes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> fetchAllRecipes(BuildContext context) async {
    try {
      final recipes = await _recipeService.fetchAllRecipes(context);
      state = AsyncValue.data(recipes);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final followedUsersRecipesProvider = StateNotifierProvider.family<
    FollowedUsersRecipesNotifier,
    AsyncValue<List<Recipe>>,
    String>((ref, userId) {
  final recipeService = ref.read(recipeServiceProvider);
  return FollowedUsersRecipesNotifier(recipeService, userId);
});
