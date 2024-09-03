import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/mealplan.dart';

class ObjehctHelper {
  List<DateTime> generateRecurrenceDates(
      DateTime startDate, DateTime endDate, Recurrence recurrence) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    // Handle different recurrence types
    if (recurrence.option == 'daily') {
      // Daily recurrence
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (recurrence.option == 'weekly') {
      // Weekly recurrence with specific days of the week
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        for (var day in recurrence.customDays!) {
          DateTime weekDayDate = _getWeekdayDate(currentDate, day);
          if (weekDayDate.isBefore(endDate) ||
              weekDayDate.isAtSameMomentAs(endDate)) {
            dates.add(weekDayDate);
          }
        }
        currentDate =
            currentDate.add(const Duration(days: 7)); // Move to the next week
      }
    } else if (recurrence.option == 'custom') {
      // Custom recurrence, similar to weekly but user-defined days of the week
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        for (var day in recurrence.customDays!) {
          DateTime weekDayDate = _getWeekdayDate(currentDate, day);
          if (weekDayDate.isBefore(endDate) ||
              weekDayDate.isAtSameMomentAs(endDate)) {
            dates.add(weekDayDate);
          }
        }
        currentDate = currentDate.add(const Duration(days: 7));
      }
    }

    // Include the endDate if it matches the recurrence pattern
    if (_isRecurrenceDay(endDate, recurrence.option, recurrence.customDays!) &&
        !dates.contains(endDate)) {
      dates.add(endDate);
    }

    return dates;
  }

// Helper function to check if a given date matches the recurrence pattern
  bool _isRecurrenceDay(
      DateTime date, String recurrenceType, List<int> daysOfWeek) {
    if (recurrenceType == 'daily') {
      return true; // Daily recurrence, every day is valid
    } else if (recurrenceType == 'weekly' || recurrenceType == 'custom') {
      return daysOfWeek.contains(date.weekday);
    }
    return false;
  }

// Helper function to get the date of a specific weekday from a given date
  DateTime _getWeekdayDate(DateTime date, int weekday) {
    int daysUntilWeekday = (weekday - date.weekday + 7) % 7;
    return date.add(Duration(days: daysUntilWeekday));
  }

// Example: Save a meal plan with recurrence
  void saveMealPlan(
      Store store,
      DateTime startDate,
      DateTime endDate,
      Recurrence recurrence,
      String name,
      String duration,
      String createdBy,
      List<String> trainees) {
    final mealPlan = MealPlan(
        name: name,
        startDate: startDate,
        endDate: endDate,
        duration: duration,
        createdBy: createdBy,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        trainees: trainees);
    store.box<MealPlan>().put(mealPlan);
  }

// Example: Retrieve and process meal plans
  List<MealPlan> getMealPlans(Store store) {
    final mealPlans = store.box<MealPlan>().getAll();
    return mealPlans;
  }
}
