import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:voltican_fitness/Features/mealplan/data/model/mealplan.dart';
import 'package:voltican_fitness/core/error/server_exception.dart';

abstract class MealPlanDataSource {
  Future<List<MealPlanModel>> getMealPlans();
  Future<MealPlanModel> getMealPlan(String id);
  Future<void> createMealPlan(MealPlanModel mealPlan);
  Future<void> updateMealPlan(MealPlanModel mealPlan);
  Future<void> deleteMealPlan(String id);
}

class MealPlanDataSourceImpl implements MealPlanDataSource {
  final Dio client;

  MealPlanDataSourceImpl(this.client);

  @override
  Future<List<MealPlanModel>> getMealPlans() async {
    final response = await client.get("/mealplans");
    if (response.statusCode == 200) {
      final List decodedJson = json.decode(response.data);
      return decodedJson.map((json) => MealPlanModel.fromJson(json)).toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<MealPlanModel> getMealPlan(String id) async {
    final response = await client.get('/mealplans/$id');
    if (response.statusCode == 200) {
      return MealPlanModel.fromJson(json.decode(response.data));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<void> createMealPlan(MealPlanModel mealPlan) async {
    final response = await client.post(
      '/mealplans',
      data: json.encode(mealPlan.toJson()),
    );
    if (response.statusCode != 201) {
      throw ServerException();
    }
  }

  @override
  Future<void> updateMealPlan(MealPlanModel mealPlan) async {
    final response = await client.put(
      'mealplans/${mealPlan.id}',
      data: json.encode(mealPlan.toJson()),
    );
    if (response.statusCode != 200) {
      throw ServerException();
    }
  }

  @override
  Future<void> deleteMealPlan(String id) async {
    final response = await client.delete('/mealplans/$id');
    if (response.statusCode != 204) {
      throw ServerException();
    }
  }
}
