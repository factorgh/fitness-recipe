// ignore_for_file: avoid_print

import 'package:fit_cibus/Features/mealplan/services/mealplan_service.dart';
import 'package:fit_cibus/models/mealplan.dart';
import 'package:fit_cibus/providers/meal_plan_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
      print('Failed to fetch meal plan: $e');
    }
  }

  Future<void> createMealPlan(MealPlan mealPlan, BuildContext context) async {
    try {
      final newMealPlan =
          await _mealPlanService.createMealPlan(mealPlan, context);
      state = newMealPlan; // Update state with newly created meal plan
    } catch (e) {
      print('Failed to create meal plan: $e');
    }
  }

  Future<void> updateMealPlan(String id, MealPlan mealPlan) async {
    try {
      final updatedMealPlan =
          await _mealPlanService.updateMealPlan(id, mealPlan);
      state = updatedMealPlan;
      await _mealPlanService
          .fetchAllMealPlans(); // Update state with updated meal plan
    } catch (e) {
      print('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String id) async {
    try {
      await _mealPlanService.deleteMealPlan(id);
      state = null; // Clear state when a meal plan is deleted
    } catch (e) {
      print('Failed to delete meal plan: $e');
    }
  }
}

// State provider for the list of meal plans
final mealPlansProvider =
    StateNotifierProvider<MealPlansNotifier, MealPlansState>((ref) {
  final mealPlanService = ref.watch(mealPlanServiceProvider);
  return MealPlansNotifier(mealPlanService);
});

class MealPlansNotifier extends StateNotifier<MealPlansState> {
  final MealPlanService _mealPlanService;
  List<MealPlan> _allMealPlans = []; // To store all meal plans

  MealPlansNotifier(this._mealPlanService) : super(const MealPlansLoading());

  Future<void> fetchAllMealPlans() async {
    state = const MealPlansLoading();
    try {
      _allMealPlans = await _mealPlanService.fetchAllMealPlans();
      state = MealPlansLoaded(_allMealPlans);
    } catch (e) {
      state = MealPlansError('Failed to fetch meal plans: $e');
    }
  }

  Future<void> addMealPlan(MealPlan mealPlan, BuildContext context) async {
    try {
      final newMealPlan =
          await _mealPlanService.createMealPlan(mealPlan, context);
      if (state is MealPlansLoaded) {
        _allMealPlans = [..._allMealPlans, newMealPlan!];
        filterByDuration('Does Not Repeat'); // Reset filter after adding
      }
    } catch (e) {
      print('Failed to add meal plan: $e');
    }
  }

  Future<void> updateMealPlan(String id, MealPlan mealPlan) async {
    try {
      final updatedMealPlan =
          await _mealPlanService.updateMealPlan(id, mealPlan);
      if (state is MealPlansLoaded) {
        _allMealPlans = (state as MealPlansLoaded)
            .mealPlans
            .map((plan) => plan.id == id ? updatedMealPlan : plan)
            .toList();
        filterByDuration('Does Not Repeat');
      }
    } catch (e) {
      print('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String id) async {
    try {
      await _mealPlanService.deleteMealPlan(id);
      if (state is MealPlansLoaded) {
        _allMealPlans = (state as MealPlansLoaded)
            .mealPlans
            .where((plan) => plan.id != id)
            .toList();
        filterByDuration('Does Not Repeat');
      }
    } catch (e) {
      print('Failed to delete meal plan: $e');
    }
  }

  void filterByDuration(String duration) {
    if (duration == 'Does Not Repeat') {
      state = MealPlansLoaded(_allMealPlans);
    } else {
      final filteredPlans =
          _allMealPlans.where((plan) => plan.duration == duration).toList();
      state = MealPlansLoaded(filteredPlans);
    }
  }
}
