import 'package:voltican_fitness/Features/mealplan/data/datasources/mealplan.dart';
import 'package:voltican_fitness/Features/mealplan/data/model/mealplan.dart';
import 'package:voltican_fitness/Features/mealplan/domain/entities/mealplan.dart';
import 'package:voltican_fitness/Features/mealplan/domain/repositories/mealplan.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/core/error/server_exception.dart';

class MealPlanRepositoryImpl implements MealPlanRepository {
  final MealPlanDataSource remoteDataSource;

  MealPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<MealPlan>>> getMealPlans() async {
    try {
      final remoteMealPlans = await remoteDataSource.getMealPlans();
      final mealPlans =
          remoteMealPlans.map((model) => model.toEntity()).toList();
      return Right(mealPlans);
    } on ServerException {
      return Left(Failure()); // Use specific Failure subclass
    }
  }

  @override
  Future<Either<Failure, MealPlan>> getMealPlan(String id) async {
    try {
      final remoteMealPlan = await remoteDataSource.getMealPlan(id);
      return Right(remoteMealPlan);
    } on ServerException {
      return Left(Failure()); // Use specific Failure subclass
    }
  }

  @override
  Future<Either<Failure, void>> createMealPlan(MealPlan mealPlan) async {
    try {
      final mealPlanModel = MealPlanModel.fromEntity(mealPlan);
      await remoteDataSource.createMealPlan(mealPlanModel);
      return const Right(null);
    } on ServerException {
      return Left(Failure()); // Use specific Failure subclass
    }
  }

  @override
  Future<Either<Failure, void>> updateMealPlan(MealPlan mealPlan) async {
    try {
      final mealPlanModel = MealPlanModel.fromEntity(mealPlan);
      await remoteDataSource.updateMealPlan(mealPlanModel);
      return const Right(null);
    } on ServerException {
      return Left(Failure()); // Use specific Failure subclass
    }
  }

  @override
  Future<Either<Failure, void>> deleteMealPlan(String id) async {
    try {
      await remoteDataSource.deleteMealPlan(id);
      return const Right(null);
    } on ServerException {
      return Left(Failure()); // Use specific Failure subclass
    }
  }
}
