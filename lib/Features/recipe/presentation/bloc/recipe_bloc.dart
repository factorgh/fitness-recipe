import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:voltican_fitness/Features/recipe/domain/entities/recipe.dart';
import 'package:voltican_fitness/Features/recipe/domain/usecases/usecases_recipe.dart';
import 'package:voltican_fitness/core/error/failure.dart';

part 'recipe_event.dart';
part 'recipe_state.dart';

class RecipeBloc extends Bloc<RecipeEvent, RecipeState> {
  final SearchRecipes searchRecipes;
  final GetRecipe getRecipe;
  final CreateRecipe createRecipe;
  final UpdateRecipe updateRecipe;
  final DeleteRecipe deleteRecipe;

  RecipeBloc({
    required this.searchRecipes,
    required this.getRecipe,
    required this.createRecipe,
    required this.updateRecipe,
    required this.deleteRecipe,
  }) : super(RecipeInitial());

  Stream<RecipeState> mapEventToState(
    RecipeEvent event,
  ) async* {
    if (event is SearchRecipesEvent) {
      yield RecipeLoading();
      final failureOrRecipes =
          await searchRecipes(SearchParams(query: event.query));
      yield failureOrRecipes.fold(
        (failure) => RecipeError(message: _mapFailureToMessage(failure)),
        (recipes) => RecipeLoaded(recipes: recipes),
      );
    } else if (event is GetRecipeEvent) {
      yield RecipeLoading();
      final failureOrRecipe = await getRecipe(Params(id: event.id));
      yield failureOrRecipe.fold(
        (failure) => RecipeError(message: _mapFailureToMessage(failure)),
        (recipe) => RecipeLoaded(recipes: [recipe]),
      );
    } else if (event is CreateRecipeEvent) {
      yield RecipeLoading();
      final failureOrSuccess = await createRecipe(event.recipe);
      yield failureOrSuccess.fold(
        (failure) => RecipeError(message: _mapFailureToMessage(failure)),
        (_) => RecipeSuccess(),
      );
    } else if (event is UpdateRecipeEvent) {
      yield RecipeLoading();
      final failureOrSuccess = await updateRecipe(event.recipe);
      yield failureOrSuccess.fold(
        (failure) => RecipeError(message: _mapFailureToMessage(failure)),
        (_) => RecipeSuccess(),
      );
    } else if (event is DeleteRecipeEvent) {
      yield RecipeLoading();
      final failureOrSuccess = await deleteRecipe(Params(id: event.id));
      yield failureOrSuccess.fold(
        (failure) => RecipeError(message: _mapFailureToMessage(failure)),
        (_) => RecipeSuccess(),
      );
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case const (Failure):
        return 'Server Failure';
      default:
        return 'Unexpected Error';
    }
  }
}
