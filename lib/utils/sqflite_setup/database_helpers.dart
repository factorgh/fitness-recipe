// ignore_for_file: unused_local_variable

import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:voltican_fitness/models/mealplan.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'drafts.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE meal_plans (
       id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        duration TEXT NOT NULL,
        startDate TEXT,
        endDate TEXT,
        datesArray TEXT,
        meals TEXT,
        trainees TEXT,
        createdBy TEXT NOT NULL,
        createdAt TEXT,
        updatedAt TEXT
      )
    ''');

    await db.execute('''
    CREATE TABLE recurrences (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      option TEXT,
      date TEXT,
      exceptions TEXT,
      customDates TEXT,
      customDays TEXT
    )
  ''');

    await db.execute('''
      CREATE TABLE meals (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        mealType TEXT,
        timeOfDay TEXT,
        date TEXT,
        recurrence TEXT,
        mealPlanId TEXT,  -- Changed to TEXT to match meal_plans id type
        FOREIGN KEY (mealPlanId) REFERENCES meal_plans(id)
      )
    ''');

    await db.execute('''
    CREATE TABLE meal_dates (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      mealId INTEGER,
      date TEXT,
      FOREIGN KEY (mealId) REFERENCES meals(id)
    )
  ''');
  }

  Future<void> insertMeal(Meal meal) async {
    final db = await database;
    int? recurrenceId;
    if (meal.recurrence != null) {
      await db.insert('recurrences', {
        'option': meal.recurrence!.option,
        'date': meal.recurrence!.date.toIso8601String(),
        'exceptions': jsonEncode(meal.recurrence!.exceptions
                ?.map((e) => e.toIso8601String())
                .toList() ??
            []),
        'customDates': jsonEncode(meal.recurrence!.customDates
                ?.map((e) => e.toIso8601String())
                .toList() ??
            []),
        'customDays': jsonEncode(meal.recurrence!.customDays ?? []),
      }).then((id) => recurrenceId = id);
    }

    await db.insert('meals', {
      'mealType': meal.mealType,
      'timeOfDay': meal.timeOfDay,
      'date': meal.date.toIso8601String(),
      'recurrence': jsonEncode(meal.recurrence?.toJson()),
      // Use null if not yet available
    });
  }

  Future<void> updateMealPlanId(String mealPlanId) async {
    final db = await database;
    await db.update(
      'meals',
      {'mealPlanId': mealPlanId},
    );
  }

  Future<void> insertRecurrence(Recurrence recurrence) async {
    final db = await database;
    await db.insert('recurrences', {
      'option': recurrence.option,
      'date': recurrence.date.toIso8601String(),
      'exceptions': jsonEncode(
          recurrence.exceptions?.map((e) => e.toIso8601String()).toList() ??
              []),
      'customDates': jsonEncode(
          recurrence.customDates?.map((e) => e.toIso8601String()).toList() ??
              []),
      'customDays': jsonEncode(recurrence.customDays ?? []),
    });
  }

  Future<List<MealPlan>> getMealPlans() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('meal_plans');
    return List.generate(maps.length, (i) {
      return MealPlan.fromJson(maps[i]);
    });
  }

  Future<void> insertMealDates(String mealId, List<DateTime> dates) async {
    final db = await database;
    final batch = db.batch();

    for (var date in dates) {
      batch.insert('meal_dates', {
        'mealId': mealId,
        'date': date.toIso8601String(),
      });
    }

    await batch.commit();
  }

  List<DateTime> generateRecurrenceDates(DateTime startDate, DateTime endDate,
      String recurrenceType, List<int> customDaysOfWeek) {
    List<DateTime> dates = [];
    DateTime currentDate = startDate;

    // Handle different recurrence types
    if (recurrenceType == 'daily') {
      // Daily recurrence
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        dates.add(currentDate);
        currentDate = currentDate.add(const Duration(days: 1));
      }
    } else if (recurrenceType == 'weekly') {
      // Weekly recurrence with specific days of the week
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        for (var day in customDaysOfWeek) {
          DateTime weekDayDate = _getWeekdayDate(currentDate, day);
          if (weekDayDate.isBefore(endDate) ||
              weekDayDate.isAtSameMomentAs(endDate)) {
            dates.add(weekDayDate);
          }
        }
        currentDate =
            currentDate.add(const Duration(days: 7)); // Move to the next week
      }
    } else if (recurrenceType == 'custom') {
      // Custom recurrence, similar to weekly but user-defined days of the week
      while (currentDate.isBefore(endDate) ||
          currentDate.isAtSameMomentAs(endDate)) {
        for (var day in customDaysOfWeek) {
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
    if (_isRecurrenceDay(endDate, recurrenceType, customDaysOfWeek) &&
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
      return daysOfWeek
          .contains(date.weekday); // Match against custom days of the week
    }
    return false;
  }

// Helper function to calculate the correct date for a specific weekday in the current week
  DateTime _getWeekdayDate(DateTime referenceDate, int targetWeekday) {
    int difference = (targetWeekday - referenceDate.weekday) % 7;
    return referenceDate.add(Duration(days: difference));
  }

  Future<void> insertMealsForDayAndRecurrence(DateTime date, List<Meal> meals,
      DateTime startDate, DateTime endDate) async {
    final db = await database;
    final batch = db.batch();

    for (var meal in meals) {
      if (meal.recurrence != null) {
        final dates = generateRecurrenceDates(
          startDate,
          endDate,
          meal.recurrence!.option,
          meal.recurrence!.customDays ?? [],
        );

        for (var mealDate in dates) {
          batch.insert('meals', {
            'mealType': meal.mealType,
            'timeOfDay': meal.timeOfDay,
            'date': mealDate.toIso8601String(),
            'recurrence': jsonEncode(meal.recurrence?.toJson()),
          });
        }
      } else {
        batch.insert('meals', {
          'mealType': meal.mealType,
          'timeOfDay': meal.timeOfDay,
          'date': date.toIso8601String(),
        });
      }
    }

    await batch.commit();
  }

  Future<void> populateMealsForRecurrence(
      DateTime startDate, DateTime endDate, List<Meal> meals) async {
    for (var meal in meals) {
      if (meal.recurrence != null) {
        final dates = generateRecurrenceDates(
          startDate,
          endDate,
          meal.recurrence!.option,
          meal.recurrence!.customDays ?? [],
        );

        await insertMealDates(meal.id!, dates);
      }
    }
  }

  Future<List<Meal>> getMeals(int mealPlanId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db
        .query('meals', where: 'mealPlanId = ?', whereArgs: [mealPlanId]);
    return List.generate(maps.length, (i) {
      return Meal.fromJson(maps[i]);
    });
  }

  Future<List<Meal>> getMealsByDate(DateTime date) async {
    final db = await database;
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

    final List<Map<String, dynamic>> maps = await db
        .query('meals', where: "date LIKE ?", whereArgs: ['$formattedDate%']);

    return List.generate(maps.length, (i) {
      return Meal.fromJson(maps[i]);
    });
  }

  Future<void> removeMeal(String recipeId) async {
    final db = await database;
    await db.delete(
      'meals',
      where: 'id = ?',
      whereArgs: [recipeId],
    );
  }

  Future<void> insertMealPlan(MealPlan mealPlan) async {
    final db = await database;

    await db.insert('meal_plans', {
      'id': mealPlan.id,
      'name': mealPlan.name,
      'duration': mealPlan.duration,
      'startDate': mealPlan.startDate?.toIso8601String(),
      'endDate': mealPlan.endDate?.toIso8601String(),
      'datesArray': jsonEncode(
          mealPlan.datesArray?.map((e) => e.toIso8601String()).toList() ?? []),
      'meals': jsonEncode(mealPlan.meals.map((e) => e.toJson()).toList()),
      'trainees': jsonEncode(mealPlan.trainees),
      'createdBy': mealPlan.createdBy,
      'createdAt': mealPlan.createdAt?.toIso8601String(),
      'updatedAt': mealPlan.updatedAt?.toIso8601String(),
    });
  }
}
