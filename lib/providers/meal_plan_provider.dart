// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';

import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/providers/meal_plan_state.dart';

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

//import 'package:flutter_riverpod/flutter_riverpod.dart';

final mealPlanServicProvider = Provider<MealPlanService>((ref) {
  return MealPlanService();
});

final mealPlansProvider =
    StateNotifierProvider<MealPlansNotifier, MealPlansState>((ref) {
  final mealPlanService = ref.watch(mealPlanServiceProvider);
  return MealPlansNotifier(mealPlanService);
});

class MealPlansNotifier extends StateNotifier<MealPlansState> {
  final MealPlanService _mealPlanService;

  MealPlansNotifier(this._mealPlanService) : super(const MealPlansLoading());

  Future<void> fetchAllMealPlans() async {
    state = const MealPlansLoading();
    try {
      final mealPlans = await _mealPlanService.fetchAllMealPlans();
      state = MealPlansLoaded(mealPlans);
    } catch (e) {
      state = MealPlansError('Failed to fetch meal plans: $e');
    }
  }

  Future<void> addMealPlan(MealPlan mealPlan) async {
    try {
      final newMealPlan = await _mealPlanService.createMealPlan(mealPlan);
      if (state is MealPlansLoaded) {
        final updatedMealPlans = [
          ...(state as MealPlansLoaded).mealPlans,
          newMealPlan
        ];
        state = MealPlansLoaded(updatedMealPlans);
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
        final updatedMealPlans = (state as MealPlansLoaded)
            .mealPlans
            .map((plan) => plan.id == id ? updatedMealPlan : plan)
            .toList();
        state = MealPlansLoaded(updatedMealPlans);
      }
    } catch (e) {
      print('Failed to update meal plan: $e');
    }
  }

  Future<void> deleteMealPlan(String id) async {
    try {
      await _mealPlanService.deleteMealPlan(id);
      if (state is MealPlansLoaded) {
        final updatedMealPlans = (state as MealPlansLoaded)
            .mealPlans
            .where((plan) => plan.id != id)
            .toList();
        state = MealPlansLoaded(updatedMealPlans);
      }
    } catch (e) {
      print('Failed to delete meal plan: $e');
    }
  }
}
