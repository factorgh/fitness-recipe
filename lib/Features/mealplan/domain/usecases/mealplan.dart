import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/mealplan/domain/entities/mealplan.dart';
import 'package:voltican_fitness/Features/mealplan/domain/repositories/mealplan.dart';
import 'package:voltican_fitness/core/error/usecase/usecase.dart';

import 'package:voltican_fitness/core/error/failure.dart';

class GetMealPlans extends UseCase<List<MealPlan>, NoParams> {
  final MealPlanRepository repository;

  GetMealPlans(this.repository);

  @override
  Future<Either<Failure, List<MealPlan>>> call(NoParams params) async {
    return await repository.getMealPlans();
  }
}

class NoParams {}

class GetMealPlan extends UseCase<MealPlan, Params> {
  final MealPlanRepository repository;

  GetMealPlan(this.repository);

  @override
  Future<Either<Failure, MealPlan>> call(Params params) async {
    return await repository.getMealPlan(params.id);
  }
}

class CreateMealPlan extends UseCase<void, MealPlan> {
  final MealPlanRepository repository;

  CreateMealPlan(this.repository);

  @override
  Future<Either<Failure, void>> call(MealPlan params) async {
    return await repository.createMealPlan(params);
  }
}

class UpdateMealPlan extends UseCase<void, MealPlan> {
  final MealPlanRepository repository;

  UpdateMealPlan(this.repository);

  @override
  Future<Either<Failure, void>> call(MealPlan params) async {
    return await repository.updateMealPlan(params);
  }
}

class DeleteMealPlan extends UseCase<void, Params> {
  final MealPlanRepository repository;

  DeleteMealPlan(this.repository);

  @override
  Future<Either<Failure, void>> call(Params params) async {
    return await repository.deleteMealPlan(params.id);
  }
}

class Params extends Equatable {
  final String id;

  const Params({required this.id});

  @override
  List<Object> get props => [id];
}
