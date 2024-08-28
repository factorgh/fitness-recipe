// ignore_for_file: use_build_context_synchronously, avoid_print

import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/commons/constants/error_handling.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';

class RecipeService {
  final DioClient client = DioClient();

  Future<void> createRecipe({
    required BuildContext context,
    required String title,
    required String description,
    required List<String> ingredients,
    required String instructions,
    required String facts,
    required File imageUrl,
    required User createdBy,
    required String period,
  }) async {
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

  Future<void> saveRecipe(String userId, String recipeId) async {
    try {
      final response = await client.dio.post(
        '/recipes/save-recipe',
        data: {
          'userId': userId,
          'recipeId': recipeId,
        },
      );

      if (response.statusCode == 200) {
        print('Recipe saved successfully');
      } else {
        print('Failed to save recipe');
      }
    } catch (e) {
      print('Error saving recipe: $e');
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
}
