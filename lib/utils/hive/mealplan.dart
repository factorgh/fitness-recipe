import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/mealplan.dart';

part 'mealplan.g.dart';

@HiveType(typeId: 2)
class MealPlan extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final String duration;
  @HiveField(2)
  final List<Meal> meals;
  @HiveField(3)
  final List<String> trainees;

  MealPlan({
    required this.name,
    required this.duration,
    required this.meals,
    required this.trainees,
  });
}
