// ignore_for_file: avoid_print

import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/services/noti_setup.dart';

class MealPlanService {
  final DioClient client = DioClient();
  // Create a new meal plan
  // Create a new meal plan
  Future<MealPlan> createMealPlan(MealPlan mealPlan) async {
    try {
      final response =
          await client.dio.post('/meal-plans', data: mealPlan.toJson());

      // Deserialize the response to a MealPlan object
      MealPlan createdMealPlan = MealPlan.fromJson(response.data);

      // Schedule notifications after successfully creating the meal plan
      final notificationService = NotificationService();
      await notificationService.scheduleMealPlanNotifications(
        mealPlanId: createdMealPlan.id!,
        creationDate: DateTime.now(),
        days: createdMealPlan.days,
        recipeAllocations: createdMealPlan.recipeAllocations,
        trainees: createdMealPlan.trainees,
      );

      return createdMealPlan;
    } catch (e) {
      // Handle error
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

  // Update an existing meal plan
  Future<MealPlan> updateMealPlan(String id, MealPlan mealPlan) async {
    try {
      final response =
          await client.dio.put('/meal-plans/$id', data: mealPlan.toJson());
      return MealPlan.fromJson(response.data);
    } catch (e) {
      // Handle error
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
}
