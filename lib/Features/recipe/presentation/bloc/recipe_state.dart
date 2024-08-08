part of 'recipe_bloc.dart';

abstract class RecipeState extends Equatable {
  const RecipeState();

  @override
  List<Object> get props => [];
}

class RecipeInitial extends RecipeState {}

class RecipeLoading extends RecipeState {}

class RecipeLoaded extends RecipeState {
  final List<Recipe> recipes;

  const RecipeLoaded({required this.recipes});

  @override
  List<Object> get props => [recipes];
}

class RecipeSuccess extends RecipeState {}

class RecipeError extends RecipeState {
  final String message;

  const RecipeError({required this.message});

  @override
  List<Object> get props => [message];
}
