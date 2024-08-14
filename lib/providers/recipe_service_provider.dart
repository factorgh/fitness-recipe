import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/services/recipe_service.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});
