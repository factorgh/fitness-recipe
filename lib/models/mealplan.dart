import 'package:flutter/foundation.dart';

class Recurrence {
  final String
      option; // "every_day", "weekly", "custom_weekly", "monthly", "bi_weekly"
  final DateTime date; // Required date for the recurrence
  final List<DateTime>? exceptions; // List of exception dates
  final List<DateTime>? customDates; // List of custom dates
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
      option: json['option'] as String? ?? 'default_option',
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
      exceptions: json['exceptions'] != null
          ? List<DateTime>.from((json['exceptions'] as List)
              .map((e) => DateTime.parse(e as String)))
          : null,
      customDates: json['customDates'] != null
          ? List<DateTime>.from((json['customDates'] as List)
              .map((e) => DateTime.parse(e as String)))
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
      'customDates': customDates?.map((e) => e.toIso8601String()).toList(),
      'customDays': customDays,
    };
  }

  @override
  String toString() {
    return 'Recurrence(option: $option, date: $date, exceptions: $exceptions, customDates: $customDates, customDays: $customDays)';
  }
}

class Meal {
  final String? id;
  final String mealType; // "breakfast", "lunch", "dinner", "snack"
  final String timeOfDay; // e.g., "08:00 AM", "12:00 PM", etc.
  final List<String>? recipes; // List of recipe IDs or names as strings
  final Recurrence? recurrence; // Optional recurrence for the meal
  final DateTime date; // Date for the meal
  final bool? isDraft;

  Meal({
    required this.mealType,
    required this.timeOfDay,
    this.recipes,
    this.recurrence,
    this.id,
    this.isDraft,
    required this.date,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'] as String?,
      mealType: json['mealType'] as String? ?? '',
      timeOfDay: json['timeOfDay'] as String? ?? '',
      recipes:
          json['recipes'] != null ? List<String>.from(json['recipes']) : null,
      isDraft: json['isDraft'] as bool?,
      recurrence: json['recurrence'] != null
          ? Recurrence.fromJson(json['recurrence'] as Map<String, dynamic>)
          : null,
      date:
          json['date'] != null ? DateTime.parse(json['date']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mealType': mealType,
      'timeOfDay': timeOfDay,
      'isDraft': isDraft,
      'recipes': recipes,
      'recurrence': recurrence?.toJson(),
      'date': date.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Meal(id:$id, mealType: $mealType, timeOfDay: $timeOfDay, recipes: $recipes, recurrence: $recurrence, date: $date, isDraft: $isDraft)';
  }
}

class MealPlan {
  final String? id;
  final String name;
  final String duration; // Duration: "Does Not Repeat", "Week", "Month", etc.
  final bool? isDraft;
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
    this.isDraft,
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
          ? List<DateTime>.from((json['datesArray'] as List)
              .map((e) => DateTime.parse(e as String)))
          : null,
      isDraft: json['isDraft'] as bool?,
      meals: json['meals'] != null
          ? List<Meal>.from((json['meals'] as List)
              .map((item) => Meal.fromJson(item as Map<String, dynamic>)))
          : [],
      trainees: json['trainees'] != null
          ? List<String>.from(json['trainees'] as List)
          : [],
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
      'isDraft': isDraft,
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
