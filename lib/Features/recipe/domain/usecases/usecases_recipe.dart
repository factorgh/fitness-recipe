import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/recipe/domain/entities/recipe.dart';
import 'package:voltican_fitness/Features/recipe/domain/repositories/recipe_repo.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:voltican_fitness/core/error/usecase/usecase.dart';

class SearchRecipes extends UseCase<List<Recipe>, SearchParams> {
  final RecipeRepository repository;

  SearchRecipes(this.repository);

  @override
  Future<Either<Failure, List<Recipe>>> call(SearchParams params) async {
    return await repository.searchRecipes(params.query);
  }
}

class SearchParams extends Equatable {
  final String query;

  const SearchParams({required this.query});

  @override
  List<Object> get props => [query];
}

class GetRecipe extends UseCase<Recipe, Params> {
  final RecipeRepository repository;

  GetRecipe(this.repository);

  @override
  Future<Either<Failure, Recipe>> call(Params params) async {
    return await repository.getRecipe(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateRecipe extends UseCase<void, Recipe> {
  final RecipeRepository repository;

  CreateRecipe(this.repository);

  @override
  Future<Either<Failure, void>> call(Recipe params) async {
    return await repository.createRecipe(params);
  }
}

class UpdateRecipe extends UseCase<void, Recipe> {
  final RecipeRepository repository;

  UpdateRecipe(this.repository);

  @override
  Future<Either<Failure, void>> call(Recipe params) async {
    return await repository.updateRecipe(params);
  }
}

class DeleteRecipe extends UseCase<void, Params> {
  final RecipeRepository repository;

  DeleteRecipe(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteRecipe(params.id);
  }
}
