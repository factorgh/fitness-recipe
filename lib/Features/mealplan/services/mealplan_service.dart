// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/services/noti_setup.dart';
import 'package:voltican_fitness/utils/native_alert.dart';

class MealPlanService {
  final DioClient client = DioClient();
  final alerts = NativeAlerts();

  // Create a new meal plan

  Future<MealPlan> createMealPlan(
      MealPlan mealPlan, BuildContext context) async {
    try {
      print('-----------------------Plan creation----------------------');
      print(mealPlan);
      final response =
          await client.dio.post('/meal-plans', data: mealPlan.toJson());

      // Deserialize the response to a MealPlan object
      MealPlan createdMealPlan = MealPlan.fromJson(response.data);

      // Schedule notifications after successfully creating the meal plan
      final notificationService = NotificationService();
      await notificationService.scheduleMealPlanNotifications(
        mealPlanId: createdMealPlan.id!,
        creationDate: DateTime.now(),
        recipeAllocations: createdMealPlan.meals,
        trainees: createdMealPlan.trainees,
      );
      NativeAlerts()
          .showSuccessAlert(context, "Meal plan created successfully");

      return createdMealPlan;
    } catch (e) {
      // Log the error (you can also use any logging library)
      debugPrint('Error creating meal plan: $e');

      // Display a snackbar with a user-friendly error message
      NativeAlerts().showErrorAlert(context,
          'Failed to create meal plan. Please check days or duration or trainees on plan to avoid conflicts.');
      // Re-throw the error if you want to handle it further up the call stack
      throw Exception('Failed to create meal plan: $e');
    }
  }

  // Fetch a single meal plan by ID
  Future<MealPlan> fetchMealPlanById(String id) async {
    try {
      final response = await client.dio.get('/meal-plans/$id');
      return MealPlan.fromJson(response.data);
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch meal plan: $e');
    }
  }

  Future<MealPlan> updateMealPlan(String mealPlanId, MealPlan mealPlan) async {
    try {
      final response = await client.dio
          .put('/meal-plans/$mealPlanId', data: mealPlan.toJson());

      if (response.statusCode == 200) {
        return MealPlan.fromJson(response.data);
      } else {
        throw Exception(
            'Failed to update meal plan: ${response.statusCode} ${response.statusMessage}');
      }
    } catch (e) {
      throw Exception('Failed to update meal plan: $e');
    }
  }

  // Delete a meal plan
  Future<void> deleteMealPlan(String id) async {
    try {
      await client.dio.delete('/meal-plans/$id');
    } catch (e) {
      // Handle error
      throw Exception('Failed to delete meal plan: $e');
    }
  }

  // Fetch all meal plans
  Future<List<MealPlan>> fetchAllMealPlans() async {
    try {
      final response = await client.dio.get('/meal-plans');
      print(response.data);
      final List<dynamic> data = response.data;
      return data.map((json) => MealPlan.fromJson(json)).toList();
    } catch (e) {
      // Handle error
      throw Exception('Failed to fetch meal plans: $e');
    }
  }

  Future<List<MealPlan>> fetchMealPlansByTrainee(String traineeId) async {
    try {
      final response = await client.dio.get('/meal-plans/trainee/$traineeId');
      print('Response data: ${response.data}');
      return (response.data as List)
          .map((mealPlanData) => MealPlan.fromJson(mealPlanData))
          .toList();
    } catch (e) {
      print('Failed to fetch meal plans: $e');
      throw Exception('Failed to fetch meal plans from serverRR');
    }
  }

  // Fetch the draft meal plan
  Future<MealPlan> getMealPlanDraft() async {
    try {
      final response = await client.dio.get('/meal-plans/meals/mealplan/draft');
      print(
          '------------------------------meal drafts--------------------------');
      print(response.data);

      // Check if a draft meal plan exists in the response
      if (response.statusCode == 200) {
        return MealPlan.fromJson(response.data);
      } else {
        throw Exception('No draft meal plan found');
      }
    } catch (e) {
      print('Error fetching draft meal plan: $e');
      throw Exception('Failed to fetch draft meal plan: $e');
    }
  }

  Future<List<Meal>> getMealByDate(DateTime date) async {
    print('----------date');
    print(date);
    String formattedDate = DateFormat('yyyy-M-d').format(date);
    try {
      final response = await client.dio.get('/meal-plans/meals/$formattedDate');
      print(
          '------------------------------meal drafts--------------------------');
      print(response.data);

      // Check if a draft meal plan exists in the response
      if (response.statusCode == 200) {
        return (response.data as List)
            .map((mealData) => Meal.fromJson(mealData))
            .toList();
      } else {
        throw Exception('No  meals found');
      }
    } catch (e) {
      print('Error fetching draft meal plan: $e');
      throw Exception('Failed to fetch draft meal plan: $e');
    }
  }
}
