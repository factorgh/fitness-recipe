// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';

import 'package:voltican_fitness/models/recipe.dart';

class Recurrence {
  final String
      option; // "every_day", "weekly", "custom_weekly", "monthly", "bi_weekly"
  final DateTime date; // Required date for the recurrence
  final List<DateTime>? exceptions; // List of exception dates
  final List<DateTime>? customDates; // List of exception dates
  final List<int>?
      customDays; // For custom weekly recurrence: 0 = Sunday, 1 = Monday, etc.

  Recurrence({
    required this.option,
    required this.date,
    this.customDates,
    this.exceptions,
    this.customDays,
  });

  factory Recurrence.fromJson(Map<String, dynamic> json) {
    return Recurrence(
      option: json['option'] != null
          ? json['option'] as String
          : 'default_option', // Add a fallback default value
      date: json['date'] != null
          ? DateTime.parse(json['date'])
          : DateTime.now(), // Fallback to current date if null
      exceptions: json['exceptions'] != null
          ? List<DateTime>.from(
              json['exceptions'].map((e) => DateTime.parse(e)))
          : null,
      customDates: json['customDates'] !=
              null // Corrected this from exceptions to customDates
          ? List<DateTime>.from(
              json['customDates'].map((e) => DateTime.parse(e)))
          : null,
      customDays: json['customDays'] != null
          ? List<int>.from(json['customDays'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'option': option,
      'date': date.toIso8601String(),
      'exceptions': exceptions?.map((e) => e.toIso8601String()).toList(),
      'customDates': exceptions?.map((e) => e.toIso8601String()).toList(),
      'customDays': customDays,
    };
  }

  @override
  String toString() {
    return 'Recurrence(option: $option, date: $date, exceptions: $exceptions, customDates: $customDates, customDays: $customDays)';
  }
}

class Meal {
  final String mealType; // "breakfast", "lunch", "dinner", "snack"
  final String timeOfDay; // e.g., "08:00 AM", "12:00 PM", etc.
  final List<Recipe> recipes; // List of Recipe objects
  final Recurrence? recurrence; // Optional recurrence for the meal
  final DateTime date; // Date for the meal

  Meal({
    required this.mealType,
    required this.timeOfDay,
    required this.recipes,
    this.recurrence,
    required this.date,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      mealType: json['mealType'] as String,
      timeOfDay: json['allocatedTime'] as String,
      recipes: json['recipes'] != null
          ? List<Recipe>.from(
              json['recipes'].map((item) => Recipe.fromJson(item)))
          : [],
      recurrence: json['recurrence'] != null
          ? Recurrence.fromJson(json['recurrence'])
          : null,
      date: DateTime.parse(json['date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'mealType': mealType,
      'timeOfDay': timeOfDay,
      'recipes': recipes.map((e) => e.toJson()).toList(),
      'recurrence': recurrence?.toJson(),
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Meal(mealType: $mealType, date: $date, timeOfDay: $timeOfDay, recipes: $recipes, recurrence: $recurrence)';
  }
}

class MealPlan {
  final String? id;
  final String name;
  final String duration; // Duration: "Does Not Repeat", "Week", "Month", etc.
  final DateTime? startDate; // Start date of the meal plan
  final DateTime? endDate; // End date of the meal plan
  final List<DateTime>? datesArray; // Array of dates for custom meal plan
  final List<Meal> meals; // List of meals
  final List<String> trainees; // List of trainee IDs
  final String createdBy; // User ID of the creator
  final DateTime? createdAt; // Timestamp of creation
  final DateTime? updatedAt; // Timestamp of last update

  MealPlan({
    this.id,
    required this.name,
    required this.duration,
    this.startDate,
    this.endDate,
    this.datesArray,
    List<Meal>? meals,
    required this.trainees,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  }) : meals = meals ?? [];

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['_id'] as String?,
      name: json['name'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      datesArray: json['datesArray'] != null
          ? List<DateTime>.from(
              json['datesArray'].map((e) => DateTime.parse(e)))
          : null,
      meals: json['meals'] != null
          ? List<Meal>.from(json['meals'].map((item) => Meal.fromJson(item)))
          : [],
      trainees:
          json['trainees'] != null ? List<String>.from(json['trainees']) : [],
      createdBy: json['createdBy'] as String? ?? '',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'duration': duration,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'datesArray': datesArray?.map((e) => e.toIso8601String()).toList(),
      'meals': meals.map((e) => e.toJson()).toList(),
      'trainees': trainees,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MealPlan(id: $id, name: $name, duration: $duration, startDate: $startDate, endDate: $endDate, datesArray: $datesArray, meals: $meals, trainees: $trainees, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant MealPlan other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.name == name &&
        other.duration == duration &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.datesArray, datesArray) &&
        listEquals(other.meals, meals) &&
        listEquals(other.trainees, trainees) &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        duration.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        datesArray.hashCode ^
        meals.hashCode ^
        trainees.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
