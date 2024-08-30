import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/mealplan.dart';

class MealService {
  Box<List<Meal>>? mealBox;

  Future<void> init() async {
    mealBox = await Hive.openBox<List<Meal>>('mealBox');
  }

  void saveMealsForDate(DateTime date, List<Meal> meals) {
    mealBox?.put(date.toIso8601String(), meals);
  }

  List<Meal> getMealsForDate(DateTime date) {
    return mealBox?.get(date.toIso8601String()) ?? [];
  }
}
