// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'recurrence.dart'; // Ensure you have this import
import 'mealplan.dart'; // Ensure you have this import
import 'meal.dart'; // Ensure you have this import

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  Box<MealPlan>? _mealPlanBox;
  Box<Recurrence>? _recurrenceBox;
  Box<Meal>? _mealBox;

  Future<void> init() async {
    _mealPlanBox = await Hive.openBox<MealPlan>('mealPlans');
    _recurrenceBox = await Hive.openBox<Recurrence>('recurrences');
    _mealBox = await Hive.openBox<Meal>('meals');
  }

  // Create or Update MealPlan
  Future<void> saveMealPlan(MealPlan mealPlan) async {
    try {
      print('---------------------------meal plan passed------------');
      print(mealPlan.id);
      print(mealPlan);
      await _mealPlanBox?.put(mealPlan.id, mealPlan);
      print('Meal plan saved successfully');
    } catch (e) {
      print('Error saving meal plan: $e');
    }
  }

  // Get MealPlan by ID
  MealPlan? getMealPlan(String id) {
    print('---------- id --------');
    print(id);
    return _mealPlanBox?.get(id);
  }

  // Get all MealPlans
  Future<List<MealPlan>> getAllMealPlans() async {
    final box = _mealPlanBox; // Retrieve your Box instance
    if (box == null) {
      return []; // Return an empty list if the box is null
    }

    // Asynchronous operation to fetch all values
    final mealPlans = box.values.toList();
    return mealPlans;
  }

  // Check if MealPlan box is empty
  bool isMealPlanBoxEmpty() {
    final box = _mealPlanBox;
    if (box == null) {
      return true; // Box is not initialized
    }
    return box.isEmpty;
  }

  // Delete MealPlan
  Future<void> deleteMealPlan(String id) async {
    await _mealPlanBox?.delete(id);
  }

  // Create or Update Recurrence
  Future<void> saveRecurrence(Recurrence recurrence) async {
    await _recurrenceBox?.put(recurrence.date.toIso8601String(), recurrence);
  }

  // Get Recurrence by Date
  Recurrence? getRecurrence(DateTime date) {
    return _recurrenceBox?.get(date.toIso8601String());
  }

  // Get all Recurrences
  List<Recurrence> getAllRecurrences() {
    return _recurrenceBox?.values.toList() ?? [];
  }

  // Check if Recurrence box is empty
  bool isRecurrenceBoxEmpty() {
    final box = _recurrenceBox;
    if (box == null) {
      return true; // Box is not initialized
    }
    return box.isEmpty;
  }

  // Delete Recurrence
  Future<void> deleteRecurrence(DateTime date) async {
    await _recurrenceBox?.delete(date.toIso8601String());
  }

  // Create or Update Meal
  Future<void> saveMeal(Meal meal) async {
    await _mealBox?.put(meal.id, meal);
  }

  // Get Meal by ID
  Meal? getMeal(String id) {
    return _mealBox?.get(id);
  }

  // Get all Meals
  List<Meal> getAllMeals() {
    return _mealBox?.values.toList() ?? [];
  }

  // Check if Meal box is empty
  bool isMealBoxEmpty() {
    final box = _mealBox;
    if (box == null) {
      return true; // Box is not initialized
    }
    return box.isEmpty;
  }

  // Delete Meal
  Future<void> deleteMeal(String id) async {
    await _mealBox?.delete(id);
  }
}
