import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/recipe/domain/entities/recipe.dart';
import 'package:voltican_fitness/core/error/failure.dart';

abstract class RecipeRepository {
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query);
  Future<Either<Failure, Recipe>> getRecipe(String id);
  Future<Either<Failure, void>> createRecipe(Recipe recipe);
  Future<Either<Failure, void>> updateRecipe(Recipe recipe);
  Future<Either<Failure, void>> deleteRecipe(String id);
}
