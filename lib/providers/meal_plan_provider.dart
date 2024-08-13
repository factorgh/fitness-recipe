// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';

import 'package:voltican_fitness/models/mealplan.dart';

// Provider for MealPlanService
final mealPlanServiceProvider = Provider<MealPlanService>((ref) {
  return MealPlanService();
});

// State provider for a single meal plan
final mealPlanProvider =
    StateNotifierProvider.autoDispose<MealPlanNotifier, MealPlan?>((ref) {
  final mealPlanService = ref.watch(mealPlanServiceProvider);
  return MealPlanNotifier(mealPlanService);
});

// State notifier for managing a single meal plan
class MealPlanNotifier extends StateNotifier<MealPlan?> {
  final MealPlanService _mealPlanService;

  MealPlanNotifier(this._mealPlanService) : super(null);

  Future<void> fetchMealPlan(String id) async {
    try {
      state = await _mealPlanService.fetchMealPlanById(id);
    } catch (e) {
      // Handle error
      print('Failed to fetch meal plan: $e');
    }
  }

  Future<void> createMealPlan(MealPlan mealPlan) async {
    try {
      final newMealPlan = await _mealPlanService.createMealPlan(mealPlan);
      state = newMealPlan; // Update state with newly created meal plan
    } catch (e) {
      // Handle error
      print('Failed to create meal plan: $e');
    }
  }

  Future<void> updateMealPlan(String id, MealPlan mealPlan) async {
    try {
      final updatedMealPlan =
          await _mealPlanService.updateMealPlan(id, mealPlan);
      state = updatedMealPlan; // Update state with updated meal plan
    } catch (e) {
      // Handle error
      print('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String id) async {
    try {
      await _mealPlanService.deleteMealPlan(id);
      state = null; // Clear state when a meal plan is deleted
    } catch (e) {
      // Handle error
      print('Failed to delete meal plan: $e');
    }
  }
}

// State provider for the list of meal plans
final mealPlansProvider =
    StateNotifierProvider<MealPlansNotifier, List<MealPlan>>((ref) {
  final mealPlanService = ref.watch(mealPlanServiceProvider);
  return MealPlansNotifier(mealPlanService);
});

// State notifier for managing a list of meal plans
class MealPlansNotifier extends StateNotifier<List<MealPlan>> {
  final MealPlanService _mealPlanService;

  MealPlansNotifier(this._mealPlanService) : super([]);

  Future<void> fetchAllMealPlans() async {
    try {
      state = await _mealPlanService.fetchAllMealPlans();
    } catch (e) {
      // Handle error
      print('Failed to fetch meal plans: $e');
    }
  }

  Future<void> addMealPlan(MealPlan mealPlan) async {
    try {
      final newMealPlan = await _mealPlanService.createMealPlan(mealPlan);
      state = [...state, newMealPlan]; // Add new meal plan to the list
    } catch (e) {
      // Handle error
      print('Failed to add meal plan: $e');
    }
  }

  Future<void> updateMealPlan(String id, MealPlan mealPlan) async {
    try {
      final updatedMealPlan =
          await _mealPlanService.updateMealPlan(id, mealPlan);
      state = state
          .map((plan) => plan.id == id ? updatedMealPlan : plan)
          .toList(); // Update meal plan in the list
    } catch (e) {
      // Handle error
    }
  }

  Future<void> deleteMealPlan(String id) async {
    try {
      await _mealPlanService.deleteMealPlan(id);
      state = state
          .where((plan) => plan.id != id)
          .toList(); // Remove meal plan from the list
    } catch (e) {
      // Handle error
      print('Failed to delete meal plan: $e');
    }
  }
}
