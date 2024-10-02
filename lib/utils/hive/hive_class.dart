// ignore_for_file: avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'hive_recurrence.dart'; // Ensure you have this import
import 'hive_mealplan.dart'; // Ensure you have this import
import 'hive_meal.dart'; // Ensure you have this import

class HiveService {
  static final HiveService _instance = HiveService._internal();

  factory HiveService() => _instance;

  HiveService._internal();

  // Box<MealPlan>? _mealPlanBox;
  Box<HiveRecurrence>? _recurrenceBox;
  Box<HiveMeal>? _mealBox;
  Box<HiveMealPlan>? _mealPlanBox;

  Future<void> init() async {
    // _mealPlanBox = await Hive.openBox<MealPlan>('mealPlans');
    _recurrenceBox = await Hive.openBox<HiveRecurrence>('recurrences');
    _mealBox = await Hive.openBox<HiveMeal>('meals');
    _mealPlanBox = await Hive.openBox<HiveMealPlan>('mealPlan');
  }

  // Create or Update MealPlan
  // Future<void> saveMealPlan(HiveMealPlan mealPlan) async {
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

  Future<List<HiveMealPlan>> getAllMealPlans() async {
    final box = _mealPlanBox; // Retrieve your Box instance
    if (box == null) {
      return []; // Return an empty list if the box is null
    }

    // Asynchronous operation to fetch all values
    final mealPlans = box.values.toList();
    return mealPlans;
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
  Future<void> saveDraftMealPlan(HiveMealPlan mealPlan) async {
    final box = await Hive.openBox<HiveMealPlan>('mealPlanDraftBox');
    await box.put('draftMealPlan', mealPlan); // Save a draft meal plan
  }

  Future<HiveMealPlan?> getDraftMealPlan() async {
    final box = await Hive.openBox<HiveMealPlan>('mealPlanDraftBox');
    return box.get('draftMealPlan');
  }

  Future<void> deleteDraftMealPlan() async {
    final box = await Hive.openBox<HiveMealPlan>('mealPlanDraftBox');
    await box.delete('draftMealPlan');
  }

  // Ends here
  List<DateTime> generateRecurringDates(
    HiveRecurrence recurrence,
    DateTime startDate,
    DateTime endDate,
    DateTime? currentTime,
  ) {
    List<DateTime> recurringDates = [];

    // Determine the starting date
    DateTime initialDate = (currentTime != null &&
            (currentTime.isAtSameMomentAs(startDate) ||
                currentTime.isAfter(startDate)) &&
            currentTime.isBefore(endDate))
        ? currentTime
        : startDate;

    print('---------------------Date selected on calendar --------------');
    print('Start date: $startDate');
    print('End date: $endDate');
    print('Current time: $currentTime');
    print('Initial currentDate: $initialDate');

    // Ensure the first date is added to the list
    if (initialDate.isBefore(endDate) ||
        initialDate.isAtSameMomentAs(endDate)) {
      recurringDates.add(initialDate);
    }

    // Define the time interval for recurrence based on the option
    Duration recurrenceInterval;

    switch (recurrence.option) {
      case 'every_day':
        recurrenceInterval = const Duration(days: 1);
        break;
      case 'weekly':
        recurrenceInterval = const Duration(days: 7);
        break;
      case 'bi_weekly':
        recurrenceInterval = const Duration(days: 14);
        break;
      case 'custom_weekly':
        recurrenceInterval = const Duration(days: 7);
        break;
      case 'monthly':
        // Special handling for monthly recurrence
        recurrenceInterval = Duration.zero; // Placeholder for monthly logic
        break;
      default:
        return recurringDates; // Return if unrecognized option
    }

    // Generate the recurring dates
    DateTime currentDate = initialDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      // Move to the next date based on the recurrence type
      if (recurrence.option == 'monthly') {
        currentDate =
            DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
      } else {
        currentDate = currentDate.add(recurrenceInterval);
      }

      // Add the new date if it's still within the range
      if (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        recurringDates.add(currentDate);
      }
    }

    // Handle custom dates if they exist within the range
    if (recurrence.customDates != null) {
      for (var customDate in recurrence.customDates!) {
        if (customDate.isAfter(startDate) && customDate.isBefore(endDate)) {
          recurringDates.add(customDate);
        }
      }
    }

    // Ensure the list has unique dates and is sorted
    recurringDates = recurringDates.toSet().toList();
    recurringDates.sort();

    print('----------------------------Filtered Recurrence Dates-------------');
    print(recurringDates);

    return recurringDates;
  }

  Future<void> saveRecurringMealsInDraft(
      List<HiveMeal> meals, DateTime startDate, DateTime endDate) async {
    // Open the Hive box for draft meals
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

    // Iterate through each meal in the provided list
    for (var meal in meals) {
      // Generate the list of recurring dates for the current meal's recurrence rules
      List<DateTime> dates = generateRecurringDates(
        meal.recurrence!,
        startDate,
        endDate,
        DateTime.now(),
      );

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

      for (var mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
        HiveMeal? meal = box.get('${date.toIso8601String()}_$mealType');
        if (meal != null) {
          mealsForDate.add(meal);
        } else {
          print('No meal found for $mealType on ${date.toIso8601String()}');
        }
      }

      return mealsForDate;
    } catch (e, stackTrace) {
      print('Error fetching meals: $e');
      print('Stack trace: $stackTrace');
      return []; // Return an empty list if an error occurs
    }
  }

  // Edit meals for date
  Future<void> updateMealForDate(DateTime startDate, DateTime endDate,
      DateTime date, HiveMeal updatedMeal, BuildContext context) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');

// Save meal for the current date

    await updateMealForSingleDate(meal: updatedMeal, date: date);
    print('--------------------------Updated Meal------------------------');
    print(updatedMeal);
    print(date);
    print(startDate);
    print(endDate);

    // Check if recurrence is present
    if (updatedMeal.recurrence != null) {
      bool saveForAll = await showConfirmationDialog(
        context: context,
        title: 'Save for Recurring Dates?',
        message: 'Do you want to save the meal for all recurring dates?',
      );

      if (saveForAll) {
        // Generate recurrence dates before filtering
        List<DateTime> recurrenceDates = generateRecurringDates(
            updatedMeal.recurrence!, startDate, endDate, date);

        // Filter to only include future dates after the selected date
        recurrenceDates = recurrenceDates
            .map((recurrenceDate) {
              // Convert to UTC if the date is not already in UTC
              return recurrenceDate.toUtc();
            })
            .where((recurrenceDate) => recurrenceDate.isAfter(date))
            .toList();

        print(
            '----------------------------Filtered Recurrence Dates-------------');
        print(recurrenceDates);

        bool overrideAll = false;
        bool skipAll = false;

        for (final recurrenceDate in recurrenceDates) {
          if (overrideAll) {
            // Override all remaining dates
            final updatedMealWithDate =
                updatedMeal.copyWith(date: recurrenceDate);
            await box.put(
                '${recurrenceDate.toIso8601String()}_${updatedMeal.mealType}',
                updatedMealWithDate);
            continue;
          }

          if (skipAll) {
            // Skip all remaining dates
            break;
          }

          final existingMeal = box.get(
              '${recurrenceDate.toIso8601String()}_${updatedMeal.mealType}');

          if (existingMeal != null &&
              existingMeal.timeOfDay == updatedMeal.timeOfDay) {
            // Ask user for each date if they want to override, skip, etc.
            String? option = await showOverrideOptionsDialog(
              context: context,
              date: recurrenceDate,
              mealType: updatedMeal.mealType,
              timeOfDay: updatedMeal.timeOfDay,
            );

            if (option == 'override') {
              final updatedMealWithDate =
                  updatedMeal.copyWith(date: recurrenceDate);
              await box.put(
                  '${recurrenceDate.toIso8601String()}_${updatedMeal.mealType}',
                  updatedMealWithDate);
            } else if (option == 'override all') {
              // Set flag to override all remaining dates
              overrideAll = true;
              final updatedMealWithDate =
                  updatedMeal.copyWith(date: recurrenceDate);
              await box.put(
                  '${recurrenceDate.toIso8601String()}_${updatedMeal.mealType}',
                  updatedMealWithDate);
            } else if (option == 'skip all') {
              // Set flag to skip all remaining dates
              skipAll = true;
            }
            // If user selects 'skip', we simply move to the next date
          } else {
            // If no existing meal, save new meal for this date
            final updatedMealWithDate =
                updatedMeal.copyWith(date: recurrenceDate);
            await box.put(
                '${recurrenceDate.toIso8601String()}_${updatedMeal.mealType}',
                updatedMealWithDate);
          }
        }
      } else {
        // Ask if they want to save for the current date only
        bool saveForCurrent = await showConfirmationDialog(
          context: context,
          title: 'Save for Current Date?',
          message: 'Do you want to save the meal only for the current date?',
        );
        if (saveForCurrent) {
          final updatedMealWithDate = updatedMeal.copyWith(date: date);
          await box.put('${date.toIso8601String()}_${updatedMeal.mealType}',
              updatedMealWithDate);
        }
      }
    } else {
      // No recurrence, update the meal for the current date only
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
  Future<void> syncMealsToMongoDB(HiveMealPlan mealPlan) async {
    final box = await Hive.openBox<HiveMeal>('mealDraftBox');
    List<HiveMeal> finalMeals = [];

    for (var date in mealPlan.datesArray!) {
      for (var mealType in ['Breakfast', 'Lunch', 'Dinner', 'Snack']) {
        HiveMeal? meal = box.get('${date.toIso8601String()}_$mealType');
        finalMeals.add(meal!);
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

  Future<void> clearMealPlanDraftBox() async {
    // Open the Hive box
    var box = await Hive.openBox<HiveMealPlan>('mealPlanDraftBox');
    print(box.values.toList());

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
        generateRecurringDates(meal.recurrence!, startDate, endDate, date);

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
      List<DateTime> recurringDates = generateRecurringDates(
          meal.recurrence!, startDate, endDate, DateTime.now());

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
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          );
        },
      ) ??
      false;
}

Future<String?> showOverrideOptionsDialog({
  required BuildContext context,
  required DateTime date,
  required String mealType,
  required String timeOfDay,
}) async {
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Override Meal for $mealType on ${date.toLocal()}?'),
        content: Text(
          'There is already a "$mealType" meal at $timeOfDay on ${date.toLocal().toString().split(' ')[0]}.\n'
          'Would you like to override it or skip this date?',
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'skip'),
            child: const Text('Skip this date'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'override'),
            child: const Text('Override this date'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'skip all'),
            child: const Text('Skip all remaining'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'override all'),
            child: const Text('Override all remaining'),
          ),
        ],
      );
    },
  );
}

//

// Ends here
// List<DateTime> generateRecurringDates(
//     HiveRecurrence recurrence, DateTime startDate, DateTime endDate) {
//   List<DateTime> recurringDates = [];
//   DateTime currentDate = startDate;

//   while (
//       currentDate.isBefore(endDate) || currentDate.isAtSameMomentAs(endDate)) {
//     switch (recurrence.option) {
//       case 'every_day':
//         recurringDates.add(currentDate);
//         currentDate = currentDate.add(const Duration(days: 1));
//         break;

//       case 'weekly':
//       case 'bi_weekly':
//       case 'custom_weekly':
//         for (int day in recurrence.customDays ?? []) {
//           DateTime customDate = currentDate.add(
//             Duration(days: (day - currentDate.weekday + 7) % 7),
//           );
//           if (customDate.isBefore(endDate) ||
//               customDate.isAtSameMomentAs(endDate)) {
//             recurringDates.add(customDate);
//           }
//         }
//         currentDate = currentDate.add(
//           recurrence.option == 'weekly'
//               ? const Duration(days: 7)
//               : const Duration(days: 14),
//         );
//         break;

//       case 'monthly':
//         for (int customDay in recurrence.customDays ?? []) {
//           DateTime tempDate = currentDate;
//           while (tempDate.month == currentDate.month) {
//             if ((tempDate.weekday == customDay) &&
//                 (tempDate.isBefore(endDate) ||
//                     tempDate.isAtSameMomentAs(endDate))) {
//               recurringDates.add(tempDate);
//             }
//             tempDate = tempDate.add(const Duration(days: 1));
//           }
//         }
//         currentDate =
//             DateTime(currentDate.year, currentDate.month + 1, currentDate.day);
//         break;
//     }
//   }

//   // Add custom dates if they exist
//   if (recurrence.customDates != null) {
//     for (var customDate in recurrence.customDates!) {
//       if (customDate.isAfter(startDate) && customDate.isBefore(endDate)) {
//         recurringDates.add(customDate);
//       }
//     }
//   }

//   // Remove any dates that are in the exceptions list
//   if (recurrence.exceptions != null) {
//     recurringDates.removeWhere((date) => recurrence.exceptions!.contains(date));
//   }

//   // Ensure no duplicates (in case custom dates and generated dates overlap)
//   recurringDates = recurringDates.toSet().toList();

//   return recurringDates;
// }
