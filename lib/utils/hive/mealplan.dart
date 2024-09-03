import 'package:hive/hive.dart';
import 'meal.dart'; // Ensure you have this import

part 'mealplan.g.dart'; // This file will be generated

@HiveType(typeId: 1)
class MealPlan extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String duration;

  @HiveField(3)
  final DateTime? startDate;

  @HiveField(4)
  final DateTime? endDate;

  @HiveField(5)
  final List<DateTime>? datesArray;

  @HiveField(6)
  final List<Meal> meals;

  @HiveField(7)
  final List<String> trainees;

  @HiveField(8)
  final String createdBy;

  @HiveField(9)
  final DateTime? createdAt;

  @HiveField(10)
  final DateTime? updatedAt;

  MealPlan({
    this.id,
    required this.name,
    required this.duration,
    this.startDate,
    this.endDate,
    this.datesArray,
    List<Meal>? meals,
    required this.trainees,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  }) : meals = meals ?? [];

  @override
  String toString() {
    return 'MealPlan(id: $id, name: $name, duration: $duration, startDate: $startDate, endDate: $endDate, datesArray: $datesArray, meals: $meals, trainees: $trainees, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }
}
