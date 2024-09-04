import 'package:hive_flutter/hive_flutter.dart';
import 'package:voltican_fitness/models/mealplan.dart';

void addMealWithRecurrence(
    Meal meal, Recurrence recurrence, DateTime startDate) {
  final mealId = meal.id;

  // Save meal to Hive meals box
  final mealsBox = Hive.box('meals');
  mealsBox.put(mealId, meal);

  // Store recurrence data
  final recurrenceBox = Hive.box('recurrence');
  recurrenceBox.put(mealId, recurrence);

  // Calculate dates based on recurrence and store in MealDates
  final mealDatesBox = Hive.box('mealDates');
  final List<DateTime> recurringDates =
      calculateRecurringDates(startDate, recurrence);

  for (DateTime date in recurringDates) {
    mealDatesBox.put(date, mealId);
  }
}

// Calculate reccurring dates
List<DateTime> calculateRecurringDates(
    DateTime startDate, Recurrence recurrence) {
  List<DateTime> dates = [];

  if (recurrence.option == 'weekly') {
    for (int day in recurrence.customDays!) {
      DateTime nextDate = startDate;
      while (nextDate.weekday != day) {
        nextDate = nextDate.add(const Duration(days: 1));
      }
      dates.add(nextDate);
    }
  } else if (recurrence.option == 'custom') {
    dates = recurrence.customDates!;
  }

  return dates;
}

// Query and display meals for selected Dates
Future<List<Meal>> getMealsForDates(List<DateTime> dates) async {
  final mealDatesBox = Hive.box('mealDates');
  final List<Meal> meals = [];

  for (DateTime date in dates) {
    final mealId = await mealDatesBox.get(date);
    if (mealId != null) {
      final mealsBox = Hive.box('meals');
      final meal = await mealsBox.get(mealId);
      if (meal != null) {
        meals.add(meal);
      }
    }
  }

  return meals;
}


// 