import 'package:fit_cibus/models/mealplan.dart';
import 'package:flutter/foundation.dart';

@immutable
abstract class MealPlansState {
  const MealPlansState();
}

class MealPlansLoading extends MealPlansState {
  const MealPlansLoading();
}

class MealPlansLoaded extends MealPlansState {
  final List<MealPlan> mealPlans;

  const MealPlansLoaded(this.mealPlans);
}

class MealPlansError extends MealPlansState {
  final String error;

  const MealPlansError(this.error);
}
