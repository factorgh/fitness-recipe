import 'package:flutter/foundation.dart';

class MealPlan {
  final String? id;
  final String name;
  final String duration;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String>? days;
  final List<String>? periods;
  final List<String> recipes; // Assuming these are the recipe IDs
  final List<String> trainees; // Assuming these are the user IDs
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MealPlan({
    this.id,
    required this.name,
    required this.duration,
    this.startDate,
    this.endDate,
    this.days,
    this.periods,
    required this.recipes,
    required this.trainees,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor to create a MealPlan object from a JSON map
  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'],
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      days: json['days'] != null ? List<String>.from(json['days']) : null,
      periods:
          json['periods'] != null ? List<String>.from(json['periods']) : null,
      recipes: List<String>.from(json['recipes']),
      trainees: List<String>.from(json['trainees']),
      createdBy: json['createdBy'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Method to convert a MealPlan object to a JSON map
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'duration': duration,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'days': days,
      'periods': periods,
      'recipes': recipes,
      'trainees': trainees,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MealPlan(id: $id, name: $name, duration: $duration, startDate: $startDate, endDate: $endDate, days: $days, periods: $periods, recipes: $recipes, trainees: $trainees, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MealPlan &&
        other.id == id &&
        other.name == name &&
        other.duration == duration &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        listEquals(other.days, days) &&
        listEquals(other.periods, periods) &&
        listEquals(other.recipes, recipes) &&
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
        days.hashCode ^
        periods.hashCode ^
        recipes.hashCode ^
        trainees.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
