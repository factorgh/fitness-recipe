// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:fit_cibus/classes/dio_client.dart';
import 'package:fit_cibus/commons/constants/error_handling.dart';
import 'package:fit_cibus/models/recipe.dart';
import 'package:fit_cibus/utils/show_snackbar.dart';
import 'package:flutter/material.dart';

class RecipeService {
  final DioClient client = DioClient();
  Future<void> createRecipe(
    BuildContext context,
    Recipe recipe,
  ) async {
    if (recipe.title.isEmpty ||
        recipe.description.isEmpty ||
        recipe.ingredients.isEmpty ||
        recipe.instructions.isEmpty ||
        recipe.facts.isEmpty ||
        recipe.status.isEmpty ||
        recipe.imageUrl.isEmpty ||
        recipe.createdBy.isEmpty) {
      showSnack(
          context, 'Please fill all required fields and upload an image.');
      return;
    }

    try {
      String imageUrl = recipe.imageUrl;

      // Check if image URL is a local file path (i.e., from the file picker)
      if (!imageUrl.startsWith('http')) {
        // It's a local file, so upload it to Cloudinary
        final cloudinary = CloudinaryPublic('daq5dsnqy', 'jqx9kpde');
        CloudinaryResponse uploadResult = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(imageUrl, folder: 'voltican_fitness'));
        imageUrl = uploadResult.secureUrl;
        print('Uploaded Image URL: $imageUrl');
      } else {
        print('Using existing Cloudinary URL: $imageUrl');
      }

      // Create new recipe object
      final myRecipe = Recipe(
        title: recipe.title,
        description: recipe.description,
        ingredients: recipe.ingredients,
        instructions: recipe.instructions,
        facts: recipe.facts,
        status: recipe.status,
        imageUrl:
            imageUrl, // Use the secure URL from Cloudinary or the existing one
        createdBy: recipe.createdBy,
        period: recipe.period,
        ratings: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('Recipe: $myRecipe');
      // Save recipe to DB
      print('Data for creating: ${myRecipe.toJson()}');
      final res = await client.dio.post('/recipes', data: myRecipe.toJson());

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnack(context, 'Recipe created successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future<void> deleteRecipe(String recipeId) async {
    try {
      await client.dio.delete('/recipes/$recipeId');
    } catch (e) {
      throw Exception('Error deleting recipe: $e');
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
      throw Exception('No recipes found');
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

  Future<Recipe?> getRecipeById(String recipeId) async {
    try {
      final response = await client.dio.get('/recipes/$recipeId');

      if (response.statusCode == 200) {
        final recipeData = response.data;
        return Recipe.fromJson(recipeData);
      } else {
        throw Exception('Failed to load recipe');
      }
    } catch (e) {
      print('Error fetching recipe by ID: $e');
      return null; // or throw Exception if you prefer
    }
  }

  Future<void> getRecipesByUser({
    required String userId,
    required BuildContext context,
    required Function(List<Recipe>) onSuccess,
  }) async {
    try {
      final res = await client.dio.get(
        '/recipes/top-trainers/recipe/$userId',
      );

      if (res.statusCode == 200) {
        // Parse the JSON data
        List<dynamic> jsonList = res.data;
        List<Recipe> recipes =
            jsonList.map((json) => Recipe.fromJson(json)).toList();
        print('Recipes for user $userId: $recipes');
        onSuccess(recipes);
      } else {
        // Handle server errors or unexpected responses
        print(
            '------------Server error failed to fetch recipes for user $userId');
      }
    } catch (e) {
      print('Error fetching recipes for user: $e');
    }
  }

  Future<void> getTopRatedRecipes({
    required BuildContext context,
    required Function(List<Recipe>) onSuccess,
  }) async {
    try {
      final res = await client.dio.get('/recipes/recipe/highest-rated');

      if (res.statusCode == 200) {
        // Assuming res.data is a List of Maps
        List<dynamic> recipesData = res.data;
        print('Top recipes data: $recipesData');

        // Convert dynamic data to List<Recipe>
        List<Recipe> recipes =
            recipesData.map((data) => Recipe.fromMap(data)).toList();

        // Call onSuccess with the List<Recipe>
        onSuccess(recipes);
      } else {
        // Handle server errors or unexpected responses
        showSnack(context, 'Failed to fetch top rated recipes');
      }
    } catch (e) {
      showSnack(context, 'Failed to fetch top rated recipes');
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
}
