import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/mealplan/services/mealplan_service.dart';
import 'package:voltican_fitness/models/mealplan.dart';

// Define a state notifier for Meal Plans
class CalendarMealplanProv extends StateNotifier<AsyncValue<List<MealPlan>>> {
  final MealPlanService mealPlanService;

  CalendarMealplanProv(this.mealPlanService)
      : super(const AsyncValue.loading()) {
    fetchMealPlans();
  }

  Future<void> fetchMealPlans() async {
    try {
      final mealPlans = await mealPlanService.fetchAllMealPlans();
      state = AsyncValue.data(mealPlans);
    } catch (e) {
      state =
          const AsyncValue.error('No meal plans available', StackTrace.empty);
    }
  }
}

// Create a provider for CalendarMealplanProv
final mealPlanProvider =
    StateNotifierProvider<CalendarMealplanProv, AsyncValue<List<MealPlan>>>(
        (ref) {
  return CalendarMealplanProv(MealPlanService());
});
