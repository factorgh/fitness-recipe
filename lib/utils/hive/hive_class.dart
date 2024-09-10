// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_recurrence.dart'; // Ensure you have this import
import 'mealplan.dart'; // Ensure you have this import
import 'hive_meal.dart'; // Ensure you have this import

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  // Box<MealPlan>? _mealPlanBox;
  Box<HiveRecurrence>? _recurrenceBox;
  Box<HiveMeal>? _mealBox;

  Future<void> init() async {
    // _mealPlanBox = await Hive.openBox<MealPlan>('mealPlans');
    _recurrenceBox = await Hive.openBox<HiveRecurrence>('recurrences');
    _mealBox = await Hive.openBox<HiveMeal>('meals');
  }

  // Create or Update MealPlan
  // Future<void> saveMealPlan(MealPlan mealPlan) async {
  //   try {
  //     print('---------------------------meal plan passed------------');
  //     print(mealPlan.id);
  //     print(mealPlan);
  //     await _mealPlanBox?.put(mealPlan.id, mealPlan);
  //     print('HiveMeal plan saved successfully');
  //   } catch (e) {
  //     print('Error saving meal plan: $e');
  //   }
  // }

  // Get MealPlan by ID
  // MealPlan? getMealPlan(String id) {
  //   print('---------- id --------');
  //   print(id);
  //   return _mealPlanBox?.get(id);
  // }

  // Get all MealPlans
  // Future<List<MealPlan>> getAllMealPlans() async {
  //   final box = _mealPlanBox; // Retrieve your Box instance
  //   if (box == null) {
  //     return []; // Return an empty list if the box is null
  //   }

  //   // Asynchronous operation to fetch all values
  //   final mealPlans = box.values.toList();
  //   return mealPlans;
  // }

  // Check if MealPlan box is empty
  // bool isMealPlanBoxEmpty() {
  //   final box = _mealPlanBox;
  //   if (box == null) {
  //     return true; // Box is not initialized
  //   }
  //   return box.isEmpty;
  // }

  // // Delete MealPlan
  // Future<void> deleteMealPlan(String id) async {
  //   await _mealPlanBox?.delete(id);
  // }

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

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      switch (recurrence.option) {
        case 'every_day':
          recurringDates.add(currentDate);
          currentDate = currentDate.add(const Duration(days: 1));
          break;

        case 'weekly':
        case 'bi_weekly':
          for (int day in recurrence.customDays!) {
            DateTime customDate = currentDate.add(
              Duration(days: (day - currentDate.weekday + 7) % 7),
            );
            if (customDate.isBefore(endDate) ||
                customDate.isAtSameMomentAs(endDate)) {
              recurringDates.add(customDate);
            }
          }
          currentDate = currentDate.add(
            recurrence.option == 'weekly'
                ? const Duration(days: 7)
                : const Duration(days: 14),
          );
          break;

        case 'custom_weekly':
          for (int customDay in recurrence.customDays!) {
            DateTime customDate = currentDate.add(
              Duration(days: (customDay - currentDate.weekday + 7) % 7),
            );
            if (customDate.isBefore(endDate) ||
                customDate.isAtSameMomentAs(endDate)) {
              recurringDates.add(customDate);
            }
          }
          currentDate =
              currentDate.add(const Duration(days: 7)); // Move to the next week
          break;

        case 'monthly':
          for (int customDay in recurrence.customDays!) {
            DateTime tempDate = currentDate;
            while (tempDate.month == currentDate.month) {
              if ((tempDate.weekday == customDay) &&
                  (tempDate.isBefore(endDate) ||
                      tempDate.isAtSameMomentAs(endDate))) {
                recurringDates.add(tempDate);
              }
              tempDate = tempDate.add(const Duration(days: 1));
            }
          }
          currentDate = DateTime(
              currentDate.year, currentDate.month + 1, currentDate.day);
          break;
      }
    }

    // Add endDate if it fits the recurrence pattern
    if (currentDate.isAtSameMomentAs(endDate)) {
      recurringDates.add(endDate);
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

  String formatDateWithoutTime(DateTime date) {
    return DateTime(date.year, date.month, date.day).toIso8601String();
  }

// Fetch meals for speicfic dates
  Future<List<HiveMeal>> fetchMealsForDate(DateTime date) async {
    print('-------------------------date for meals------------------------');
    print(date);

    try {
      final box = await Hive.openBox<HiveMeal>('mealDraftBox');
      List<HiveMeal> mealsForDate = [];

      // Format the date without time and timezone
      // String dateKey = formatDateWithoutTime(date);

      // print('----------formated date------------');
      // print(dateKey);

      // Retrieve meals for predefined meal types
      for (var mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
        HiveMeal? meal = box.get('${date.toIso8601String()}_$mealType');
        if (meal != null) {
          mealsForDate.add(meal);
        }
      }

      return mealsForDate;
    } catch (e) {
      print('Error fetching meals: $e');
      return []; // Return an empty list if an error occurs
    }
  }

  // Edit meals for date
  Future<void> updateMealForDate(DateTime startDate, DateTime endDate,
      DateTime date, HiveMeal updatedMeal, BuildContext context) async {
    print(
        '-----------------------Data check for updating meal----------------------');
    print('---------${updatedMeal.recurrence}-----------');

    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // If recurrence is not null, show confirmation dialog
    if (updatedMeal.recurrence != null) {
      bool confirmOverride = await showConfirmationDialog(
        context: context,
        title: 'Confirm Override',
        message:
            'Do you want to override the "${updatedMeal.mealType}" meal at '
            '${updatedMeal.timeOfDay} for all recurring days?',
      );

      if (confirmOverride) {
        // If confirmed, update meals according to recurrence
        await updateRecurringMealsInDraft(
          meal: updatedMeal,
          date: date,
          updateOption: 'future',
          startDate: startDate,
          endDate: endDate,
        );
      } else {
        // If not confirmed, update only the specified date
        final updatedMealWithDate = updatedMeal.copyWith(date: date);

        await box.put('${date.toIso8601String()}_${updatedMeal.mealType}',
            updatedMealWithDate);
      }
    } else {
      // If no recurrence, just update for the specific date
      final updatedMealWithDate = updatedMeal.copyWith(date: date);

      await box.put('${date.toIso8601String()}_${updatedMeal.mealType}',
          updatedMealWithDate);
    }
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
  void saveMealDraft(List<String> recipes, String time, String recurrence,
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

  Future<List<HiveMeal>> fetchAllMeals() async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Retrieve all the values from the box
    final allMeals = box.values.toList().cast<HiveMeal>();

    // Close the box after retrieving data
    await box.close();

    return allMeals;
  }

  // Clear the meal draft box
  Future<void> clearMealDraftBox() async {
    // Open the Hive box
    var box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Clear the box
    await box.clear();

    // Close the box
    await box.close();
  }

  Future<void> updateRecurringMealsInDraft({
    required HiveMeal meal,
    required DateTime date,
    required String updateOption, // "single", "future", or "all"
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // If "single", only update the meal for the selected date.
    if (updateOption == 'single') {
      await box.put('${date.toIso8601String()}_${meal.mealType}', meal);
      return; // Exit since no further changes are needed.
    }

    // Generate recurring dates for the meal within the given range
    List<DateTime> dates =
        generateRecurringDates(meal.recurrence!, startDate, endDate);

    print('--------------------Recurring dates--------------------');
    print(dates);

    // If "future", update meals from the current date onward.
    if (updateOption == 'future') {
      for (var d in dates) {
        if (d.isAfter(date) || d.isAtSameMomentAs(date)) {
          print('Updating meal for date: $d');
          await box.put('${d.toIso8601String()}_${meal.mealType}',
              meal.copyWith(date: d));
          print('Meal saved for date: $d');
        } else {
          print('Skipping date: $d');
        }
      }
    }

    // If "all", update meals for all matching dates.
    if (updateOption == 'all') {
      for (var d in dates) {
        // Update all dates in the recurrence
        await box.put(
            '${d.toIso8601String()}_${meal.mealType}', meal.copyWith(date: d));
      }
    }
  }

  // Update a particular dates meal
  Future<void> updateMealForSingleDate({
    required HiveMeal meal,
    required DateTime date,
  }) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    HiveMeal updatedMeal = meal.copyWith(date: date);

    await box.put('${date.toIso8601String()}_${meal.mealType}', updatedMeal);
  }

  Future<void> saveMeals({
    required List<HiveMeal> meals,
    required String updateOption, // "single", "future", or "all"
    required DateTime date,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Iterate through each meal passed to the function
    for (var meal in meals) {
      // If "single", only save the meal for the specified date
      if (updateOption == 'single') {
        await box.put('${date.toIso8601String()}_${meal.mealType}',
            meal.copyWith(date: date));
        continue; // Skip further processing for this meal
      }

      // Generate the list of recurring dates for this meal's recurrence rule
      List<DateTime> recurringDates =
          generateRecurringDates(meal.recurrence!, startDate, endDate);

      // If "future", save meals for dates starting from the given date onward
      if (updateOption == 'future') {
        final futureDates = recurringDates
            .where((d) => d.isAfter(date) || d.isAtSameMomentAs(date))
            .toList();
        for (var futureDate in futureDates) {
          final updatedMeal = meal.copyWith(date: futureDate);
          await box.put(
              '${futureDate.toIso8601String()}_${meal.mealType}', updatedMeal);
        }
        continue;
      }

      // If "all", save meals for all dates in the recurrence range
      if (updateOption == 'all') {
        for (var recurringDate in recurringDates) {
          final updatedMeal = meal.copyWith(date: recurringDate);
          await box.put('${recurringDate.toIso8601String()}_${meal.mealType}',
              updatedMeal);
        }
      }
    }
  }

  // Push list of meals to the draft on the inititial render
  Future<void> saveMealListToDraftBox(List<HiveMeal> meals) async {
    print('----------------------All Meals to Draft--------------------');
    print(meals);

    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Iterate through the list of meals
    for (var meal in meals) {
      // Use the meal's date and type as a unique key for storage
      await box.put('${meal.date!.toIso8601String()}_${meal.mealType}', meal);
    }
  }
}

Future<bool> showConfirmationDialog({
  required String title,
  required String message,
  required BuildContext context,
}) async {
  // Replace this with your actual dialog implementation
  return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
            ],
          );
        },
      ) ??
      false;
}
