// ignore_for_file: avoid_print

import 'package:fit_cibus/Features/mealplan/services/mealplan_service.dart';
import 'package:fit_cibus/models/mealplan.dart';
import 'package:fit_cibus/providers/meal_plan_provider.dart';
import 'package:fit_cibus/providers/meal_plan_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final traineeMealPlansProvider =
    StateNotifierProvider<TraineeMealPlansNotifier, MealPlansState>((ref) {
  final mealPlanService = ref.watch(mealPlanServiceProvider);
  return TraineeMealPlansNotifier(mealPlanService);
});

class TraineeMealPlansNotifier extends StateNotifier<MealPlansState> {
  final MealPlanService _mealPlanService;
  List<MealPlan> _traineeMealPlans = []; // Store trainee meal plans

  TraineeMealPlansNotifier(this._mealPlanService)
      : super(const MealPlansLoading());

  Future<void> fetchTraineeMealPlans(String traineeId) async {
    state = const MealPlansLoading();
    try {
      // Fetch meal plans by trainee ID
      final fetchedMealPlans =
          await _mealPlanService.fetchMealPlansByTrainee(traineeId);

      // Print fetched meal plans to verify data
      print('Fetched Meal Plans: $fetchedMealPlans');

      // Update internal state list
      _traineeMealPlans = fetchedMealPlans;

      // Set the state to loaded with the fetched data
      state = MealPlansLoaded(_traineeMealPlans);

      // Print state to verify assignment
      print('State after fetch: $state');
    } catch (e) {
      // Set state to error if fetching fails
      state = MealPlansError('Failed to fetch trainee meal plans: $e');

      // Print error
      print('Error fetching meal plans: $e');
    }
  }
}
