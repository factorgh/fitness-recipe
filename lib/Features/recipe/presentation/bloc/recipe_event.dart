part of 'recipe_bloc.dart';

abstract class RecipeEvent extends Equatable {
  const RecipeEvent();

  @override
  List<Object> get props => [];
}

class SearchRecipesEvent extends RecipeEvent {
  final String query;

  const SearchRecipesEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetRecipeEvent extends RecipeEvent {
  final String id;

  const GetRecipeEvent({required this.id});

  @override
  List<Object> get props => [id];
}

class CreateRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const CreateRecipeEvent({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class UpdateRecipeEvent extends RecipeEvent {
  final Recipe recipe;

  const UpdateRecipeEvent({required this.recipe});

  @override
  List<Object> get props => [recipe];
}

class DeleteRecipeEvent extends RecipeEvent {
  final String id;

  const DeleteRecipeEvent({required this.id});

  @override
  List<Object> get props => [id];
}
