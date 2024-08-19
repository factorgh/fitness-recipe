import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/providers/recipe_service_provider.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

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
}

final followedUsersRecipesProvider = StateNotifierProvider.family<
    FollowedUsersRecipesNotifier,
    AsyncValue<List<Recipe>>,
    String>((ref, userId) {
  final recipeService = ref.read(recipeServiceProvider);
  return FollowedUsersRecipesNotifier(recipeService, userId);
});
