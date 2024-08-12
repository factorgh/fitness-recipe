// ignore_for_file: use_build_context_synchronously

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

  void createRecipe({
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
    try {
      // Get cloudinary instance
      final cloudinary = CloudinaryPublic('daq5dsnqy', 'jqx9kpde');
      // Upload image to cloudinary
      CloudinaryResponse uploadResult = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(imageUrl.path, folder: 'voltican_fitness'));
      final image = uploadResult.secureUrl;
      print(image);

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

      print(recipe);
      // Save recipe to db
      final res = await client.dio.post('/recipes', data: recipe.toJson());

      httpErrorHandle(
          response: res,
          context: context,
          onSuccess: () {
            showSnack(context, 'Recipe create Successfully!');
            Navigator.pop(context);
          });
    } catch (e) {
      print(e.toString());
      showSnack(context, 'Error adding product: ${e.toString()}');
    }
  }

  Future<List<Recipe>> fetchAllRecipes(BuildContext context) async {
    List<Recipe> recipeList = [];
    try {
      final res = await client.dio.get('/recipes');
      print(res.data);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          final List<dynamic> data = res.data;
          for (var item in data) {
            recipeList.add(Recipe.fromJson(item as Map<String, dynamic>));
          }
        },
      );
    } catch (e) {
      showSnack(context, e.toString());
    }
    return recipeList;
  }
}
