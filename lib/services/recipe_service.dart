// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/commons/constants/error_handling.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/saved_recipe_provider.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';

class RecipeService {
  final DioClient client = DioClient();

  Future<void> createRecipe(
      {required BuildContext context,
      required String title,
      required String description,
      required List<String> ingredients,
      required String instructions,
      required String facts,
      required File imageUrl,
      required User createdBy,
      required String period,
      required WidgetRef ref}) async {
    if (title.isEmpty ||
        description.isEmpty ||
        ingredients.isEmpty ||
        instructions.isEmpty ||
        facts.isEmpty ||
        imageUrl.path.isEmpty) {
      showSnack(
          context, 'Please fill all required fields and upload an image.');
      return;
    }

    try {
      // Get Cloudinary instance
      final cloudinary = CloudinaryPublic('daq5dsnqy', 'jqx9kpde');
      // Upload image to Cloudinary
      CloudinaryResponse uploadResult = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(imageUrl.path, folder: 'voltican_fitness'));
      final image = uploadResult.secureUrl;
      print('Image URL: $image');

      // Create new recipe object
      final recipe = Recipe(
          title: title,
          description: description,
          ingredients: ingredients,
          instructions: instructions,
          facts: facts,
          imageUrl: image,
          createdBy: createdBy.id,
          period: period,
          ratings: [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now());

      print('Recipe: $recipe');
      // Save recipe to DB
      final res = await client.dio.post('/recipes', data: recipe.toJson());

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnack(context, 'Recipe created successfully!');
            // Refresh or reload recipes here
            ref.read(savedRecipesProvider.notifier).loadUserRecipes();
            Navigator.pop(context);
          });
    } catch (e) {
      print('Error: ${e.toString()}');
      showSnack(context, 'Error adding recipe: ${e.toString()}');
    }
  }

  Future<List<Recipe>> fetchAllRecipes(BuildContext context) async {
    List<Recipe> recipeList = [];
    try {
      final res = await client.dio.get('/recipes');
      print('Response Data: ${res.data}');

      // Handle the HTTP response
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> data = res.data;
          recipeList = data
              .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e) {
      showSnack(context, 'Error fetching recipes: ${e.toString()}');
    }
    return recipeList;
  }

  // Future<void> saveRecipe(String userId, String recipeId) async {
  //   try {
  //     final response = await client.dio.post(
  //       '/recipes/save-recipe',
  //       data: {
  //         'userId': userId,
  //         'recipeId': recipeId,
  //       },
  //     );

  //     if (response.statusCode == 200) {
  //       print('Recipe saved successfully');
  //     } else {
  //       print('Failed to save recipe');
  //     }
  //   } catch (e) {
  //     print('Error saving recipe: $e');
  //   }
  // }

  Future<List<Recipe>> fetchSavedRecipes(String userId) async {
    try {
      final response =
          await client.dio.get('/recipes/user/$userId/saved-recipes/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((recipe) => Recipe.fromJson(recipe)).toList();
      } else {
        throw Exception('Failed to load saved recipes');
      }
    } catch (e) {
      throw Exception('Error loading saved recipes: $e');
    }
  }

  Future<List<Recipe>> fetchRecipesByUser() async {
    try {
      final response = await client.dio.get('/recipes/user/by-user/');

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        return data.map((recipe) => Recipe.fromJson(recipe)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error loading recipes: $e');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await client.dio.delete('/recipes/$recipeId');
    } catch (e) {
      throw Exception('Error deleting recipe: $e');
    }
  }

  Future<void> updateRecipe(
      String recipeId, Map<String, dynamic> updatedRecipe) async {
    try {
      final response = await client.dio.put(
        '/recipes/$recipeId',
        data: updatedRecipe,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update recipe');
      }
    } catch (e) {
      throw Exception('Error updating recipe: $e');
    }
  }

  Future<List<Recipe>> fetchFollowedUsersRecipes(String userId) async {
    try {
      final response =
          await client.dio.get('/recipes/user/$userId/followed-recipes');
      return (response.data as List)
          .map((recipe) => Recipe.fromJson(recipe))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch followed users\' recipes: $e');
    }
  }

  void rateRecipe({
    required BuildContext context,
    required String recipeId,
    required double rating,
  }) async {
    final response = await client.dio.post(
        '/recipes/rate-recipe/recipe/$recipeId',
        data: {'rating': rating});
    httpErrorHandle(
        response: response,
        context: context,
        onSuccess: () async {
          showSnack(context, 'Rating submitted successfully!');
        });
  }

  Future<void> getTopRatedRecipes({
    required BuildContext context,
    required Function(List<dynamic>) onSuccess,
  }) async {
    try {
      final res = await client.dio.get('/recipes/recipe/highest-rated');

      if (res.statusCode == 200) {
        List<dynamic> recipes = res.data;
        print('Top recipes: $recipes');
        onSuccess(recipes);
      } else {
        // Handle server errors or unexpected responses
        showSnack(context, 'Failed to fetch top trainers');
      }
    } catch (e) {
      print('Error fetching top trainers: $e');
      showSnack(context, 'Failed to fetch top rated recipes');
    }
  }

// Save a recipe
  Future<bool> saveRecipe(String userId, String recipeId) async {
    try {
      final response = await client.dio.post(
        '/recipes/recipe/save',
        data: {
          'userId': userId,
          'recipeId': recipeId,
        },
      );

      if (response.statusCode == 200) {
        return true; // Recipe saved successfully
      } else {
        return false; // Failed to save the recipe
      }
    } catch (e) {
      print('Error saving recipe: $e');
      return false;
    }
  }

  // Remove a saved recipe
  Future<bool> removeSavedRecipe(String userId, String recipeId) async {
    try {
      final response = await client.dio.post(
        '/recipes/recipe/remove',
        data: {
          'userId': userId,
          'recipeId': recipeId,
        },
      );

      if (response.statusCode == 200) {
        return true; // Recipe removed successfully
      } else {
        return false; // Failed to remove the recipe
      }
    } catch (e) {
      print('Error removing recipe: $e');
      return false;
    }
  }

  Future<List<Recipe>> fetchRecipesByMealPeriod(String mealPeriod) async {
    try {
      final response = await client.dio.get(
        '/recipes/recipe/mealPeriod',
        data: {'mealPeriod': mealPeriod},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Recipe.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load recipes');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  Future<void> getRecipesByUser({
    required String userId,
    required BuildContext context,
    required Function(List<dynamic>) onSuccess,
  }) async {
    try {
      final res = await client.dio.get(
        '/recipes/top-trainers/recipe/$userId',
      );

      if (res.statusCode == 200) {
        // Directly handle the response data
        List<dynamic> recipes = res.data;
        print('Recipes for user $userId: $recipes');
        onSuccess(recipes);
      } else {
        // Handle server errors or unexpected responses
        showSnack(context, 'Failed to fetch recipes for user');
      }
    } catch (e) {
      print('Error fetching recipes for user: $e');
      showSnack(context, 'Failed to fetch recipes for user');
    }
  }
}
