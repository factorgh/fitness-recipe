import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/recipe.dart';

part 'meal.g.dart';

@HiveType(typeId: 1)
class Meal extends HiveObject {
  @HiveField(0)
  final String mealType;
  @HiveField(1)
  final String timeOfDay;
  @HiveField(2)
  final List<Recipe> recipes;
  @HiveField(3)
  final DateTime date;

  Meal({
    required this.mealType,
    required this.timeOfDay,
    required this.recipes,
    required this.date,
  });
}
