import 'package:dio/dio.dart';

import 'package:voltican_fitness/Features/recipe/data/models/recipe.dart';
import 'package:voltican_fitness/core/error/server_exception.dart';

abstract class RecipeRemoteDataSource {
  Future<List<RecipeModel>> searchRecipes(String query);
  Future<RecipeModel> getRecipe(String id);
  Future<void> createRecipe(RecipeModel recipe);
  Future<void> updateRecipe(RecipeModel recipe);
  Future<void> deleteRecipe(String id);
}

class RecipeRemoteDataSourceImpl implements RecipeRemoteDataSource {
  final Dio client;

  RecipeRemoteDataSourceImpl({required this.client});

  @override
  Future<List<RecipeModel>> searchRecipes(String query) async {
    final response =
        await client.get('/recipes', queryParameters: {'q': query});
    if (response.statusCode == 200) {
      final recipes = (response.data as List)
          .map((json) => RecipeModel.fromJson(json))
          .toList();
      return recipes;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<RecipeModel> getRecipe(String id) async {
    final response = await client.get('/recipes/$id');
    if (response.statusCode == 200) {
      return RecipeModel.fromJson(response.data);
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createRecipe(RecipeModel recipe) async {
    final response = await client.post('/recipes', data: recipe.toJson());
    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateRecipe(RecipeModel recipe) async {
    final response =
        await client.put('/recipes/${recipe.id}', data: recipe.toJson());
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteRecipe(String id) async {
    final response = await client.delete('/recipes/$id');
    if (response.statusCode != 204) {
      throw ServerException();
    }
  }
}
