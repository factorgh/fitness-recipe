import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/recipe/data/datasource/remote_source.dart';
import 'package:voltican_fitness/Features/recipe/domain/entities/recipe.dart';
import 'package:voltican_fitness/Features/recipe/domain/repositories/recipe_repo.dart';
import 'package:voltican_fitness/Features/recipe/data/models/recipe.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:voltican_fitness/core/error/server_exception.dart';

class RecipeRepositoryImpl implements RecipeRepository {
  final RecipeRemoteDataSource remoteDataSource;

  RecipeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<Recipe>>> searchRecipes(String query) async {
    try {
      final recipes = await remoteDataSource.searchRecipes(query);
      return Right(recipes.cast<Recipe>());
    } on ServerException {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, Recipe>> getRecipe(String id) async {
    try {
      final recipe = await remoteDataSource.getRecipe(id);
      return Right(recipe as Recipe);
    } on ServerException {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> createRecipe(Recipe recipe) async {
    try {
      await remoteDataSource.createRecipe(recipe as RecipeModel);
      return const Right(null);
    } on ServerException {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> updateRecipe(Recipe recipe) async {
    try {
      await remoteDataSource.updateRecipe(recipe as RecipeModel);
      return const Right(null);
    } on ServerException {
      return Left(Failure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteRecipe(String id) async {
    try {
      await remoteDataSource.deleteRecipe(id);
      return const Right(null);
    } on ServerException {
      return Left(Failure());
    }
  }
}
