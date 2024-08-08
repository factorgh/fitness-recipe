import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/mealplan/domain/entities/mealplan.dart';

import 'package:voltican_fitness/core/error/failure.dart';

abstract class MealPlanRepository {
  Future<Either<Failure, List<MealPlan>>> getMealPlans();
  Future<Either<Failure, MealPlan>> getMealPlan(String id);
  Future<Either<Failure, void>> createMealPlan(MealPlan mealPlan);
  Future<Either<Failure, void>> updateMealPlan(MealPlan mealPlan);
  Future<Either<Failure, void>> deleteMealPlan(String id);
}
