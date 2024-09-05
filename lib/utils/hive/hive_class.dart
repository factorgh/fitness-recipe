// ignore_for_file: avoid_print

import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/recipe.dart';
import 'hive_recurrence.dart'; // Ensure you have this import
import 'mealplan.dart'; // Ensure you have this import
import 'hive_meal.dart'; // Ensure you have this import

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  Box<MealPlan>? _mealPlanBox;
  Box<HiveRecurrence>? _recurrenceBox;
  Box<HiveMeal>? _mealBox;

  Future<void> init() async {
    _mealPlanBox = await Hive.openBox<MealPlan>('mealPlans');
    _recurrenceBox = await Hive.openBox<HiveRecurrence>('recurrences');
    _mealBox = await Hive.openBox<HiveMeal>('meals');
  }

  // Create or Update MealPlan
  Future<void> saveMealPlan(MealPlan mealPlan) async {
    try {
      print('---------------------------meal plan passed------------');
      print(mealPlan.id);
      print(mealPlan);
      await _mealPlanBox?.put(mealPlan.id, mealPlan);
      print('HiveMeal plan saved successfully');
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

  // Create or Update HiveRecurrence
  Future<void> saveRecurrence(HiveRecurrence recurrence) async {
    await _recurrenceBox?.put(recurrence.date.toIso8601String(), recurrence);
  }

  // Get HiveRecurrence by Date
  HiveRecurrence? getRecurrence(DateTime date) {
    return _recurrenceBox?.get(date.toIso8601String());
  }

  // Get all Recurrences
  List<HiveRecurrence> getAllRecurrences() {
    return _recurrenceBox?.values.toList() ?? [];
  }

  // Check if HiveRecurrence box is empty
  bool isRecurrenceBoxEmpty() {
    final box = _recurrenceBox;
    if (box == null) {
      return true; // Box is not initialized
    }
    return box.isEmpty;
  }

  // Delete HiveRecurrence
  Future<void> deleteRecurrence(DateTime date) async {
    await _recurrenceBox?.delete(date.toIso8601String());
  }

  // Check if HiveMeal box is empty
  bool isMealBoxEmpty() {
    final box = _mealBox;
    if (box == null) {
      return true; // Box is not initialized
    }
    return box.isEmpty;
  }

  // Delete HiveMeal
  Future<void> deleteMeal(String id) async {
    await _mealBox?.delete(id);
  }

  // Draft system for meal plan
  Future<void> saveDraftMealPlan(MealPlan mealPlan) async {
    final box = await Hive.openBox<MealPlan>('mealPlanDraftBox');
    await box.put('draftMealPlan', mealPlan); // Save a draft meal plan
  }

  Future<MealPlan?> getDraftMealPlan() async {
    final box = await Hive.openBox<MealPlan>('mealPlanDraftBox');
    return box.get('draftMealPlan');
  }

  Future<void> deleteDraftMealPlan() async {
    final box = await Hive.openBox<MealPlan>('mealPlanDraftBox');
    await box.delete('draftMealPlan');
  }
  // Ends here

  List<DateTime> generateRecurringDates(
      HiveRecurrence recurrence, DateTime startDate, DateTime endDate) {
    List<DateTime> recurringDates = [];
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate)) {
      switch (recurrence.option) {
        case 'every_day':
          recurringDates.add(currentDate);
          currentDate = currentDate.add(const Duration(days: 1));
          break;
        case 'weekly':
          recurringDates.add(currentDate);
          currentDate = currentDate.add(const Duration(days: 7));
          break;
        case 'bi_weekly':
          recurringDates.add(currentDate);
          currentDate = currentDate.add(const Duration(days: 14));
          break;
        case 'custom_weekly':
          // Add only days that match customDays
          for (int customDay in recurrence.customDays!) {
            DateTime customDate = currentDate
                .add(Duration(days: (customDay - currentDate.weekday + 7) % 7));
            if (customDate.isBefore(endDate)) recurringDates.add(customDate);
          }
          currentDate = currentDate.add(const Duration(days: 7));
          break;
        case 'monthly':
          recurringDates.add(currentDate);
          currentDate = DateTime(
              currentDate.year, currentDate.month + 1, currentDate.day);
          break;
      }
    }

    return recurringDates;
  }

  Future<void> saveRecurringMealsInDraft(
      List<HiveMeal> meals, DateTime startDate, DateTime endDate) async {
    // Open the Hive box for draft meals
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Iterate through each meal in the provided list
    for (var meal in meals) {
      // Generate the list of recurring dates for the current meal's recurrence rules
      List<DateTime> dates =
          generateRecurringDates(meal.recurrence!, startDate, endDate);

      // Iterate through each date for the current meal
      for (var date in dates) {
        // Create a new meal object for the current date
        HiveMeal newMeal = HiveMeal(
          mealType: meal.mealType,
          timeOfDay: meal.timeOfDay,
          isDraft: meal.isDraft,
          recipes: meal.recipes,
          recurrence: meal.recurrence,
          date: date,
        );

        // Save the meal for this date in the draft
        await box.put('${date.toIso8601String()}_${meal.mealType}', newMeal);
      }
    }
  }

// Fetch meals for speicfic dates
  Future<List<HiveMeal>> fetchMealsForDate(DateTime date) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');
    List<HiveMeal> mealsForDate = [];

    for (var mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
      HiveMeal? meal = box.get('${date.toIso8601String()}_$mealType');
      if (meal != null) {
        mealsForDate.add(meal);
      }
    }

    return mealsForDate;
  }

  // Edit meals for date
  Future<void> updateMealForDate(DateTime date, HiveMeal updatedMeal) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');
    await box.put(
        '${date.toIso8601String()}_${updatedMeal.mealType}', updatedMeal);
  }

  // Delete meal for a specific date
  Future<void> deleteMealForDate(DateTime date, String mealType) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');
    await box.delete('${date.toIso8601String()}_$mealType');
  }

  // Sync meal to database
  Future<void> syncMealsToMongoDB(MealPlan mealPlan) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');
    List<HiveMeal> finalMeals = [];

    for (var date in mealPlan.datesArray!) {
      for (var mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
        HiveMeal? meal = box.get('${date.toIso8601String()}_$mealType');
        if (meal != null) {
          finalMeals.add(meal);
        }
      }
    }

    // Send finalMeals to MongoDB
    print(finalMeals);
  }

  // Save draft meal to Hive
  void saveMealDraft(List<Recipe> recipes, String time, String recurrence,
      List<DateTime> dates, String mealType) {
    final mealBox = Hive.box('meals');
    final newMeal = HiveMeal(
      mealType: mealType,
      recipes: recipes,
      timeOfDay: time,
      recurrence: HiveRecurrence(option: recurrence, date: dates.first),
      date: dates.first,
      isDraft: true,
    );

    mealBox.put(newMeal.id, newMeal);
  }
}
