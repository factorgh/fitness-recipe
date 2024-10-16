import 'package:fit_cibus/services/recipe_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService();
});
