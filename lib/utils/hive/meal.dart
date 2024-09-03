import 'package:hive/hive.dart';

part 'meal.g.dart'; // This file will be generated

@HiveType(typeId: 0)
class Meal extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String mealType;

  @HiveField(2)
  final String timeOfDay;

  @HiveField(3)
  final List<String> recipes;

  @HiveField(4)
  final String recurrence;

  @HiveField(5)
  final DateTime date;

  Meal({
    required this.id,
    required this.mealType,
    required this.timeOfDay,
    required this.recipes,
    required this.recurrence,
    required this.date,
  });
}
