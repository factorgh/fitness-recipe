import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/utils/hive/services/meal_service_hive.dart';

class HiveMealPlanService {
  Box<MealPlan>? mealPlanBox;
  MealService mealService = MealService();

  Future<void> init() async {
    mealPlanBox = await Hive.openBox<MealPlan>('mealPlanBox');
    mealService.init();
  }

  void saveMealPlan(String mealPlanName, List<String> trainees, String duration,
      String createdBy, DateTime startDate, DateTime endDate) {
    List<Meal> allMeals = [];
    mealService.mealBox?.values.forEach((meals) {
      allMeals.addAll(meals);
    });

    MealPlan mealPlan = MealPlan(
        name: mealPlanName,
        duration: duration,
        meals: allMeals,
        trainees: trainees,
        createdBy: createdBy,
        startDate: startDate,
        endDate: endDate);

    mealPlanBox?.put(mealPlanName, mealPlan);
  }
}
