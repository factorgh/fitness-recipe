import 'package:flutter/foundation.dart';

class RecipeAllocation {
  final String recipeId;
  final DateTime allocatedTime;

  RecipeAllocation({
    required this.recipeId,
    required this.allocatedTime,
  });

  factory RecipeAllocation.fromJson(Map<String, dynamic> json) {
    return RecipeAllocation(
      recipeId: json['recipeId'] as String,
      allocatedTime: DateTime.parse(json['allocatedTime']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'recipeId': recipeId,
      'allocatedTime': allocatedTime.toIso8601String(),
    };
  }
}

class MealPlan {
  final String? id;
  final String name;
  final String duration;
  final DateTime? startDate;
  final DateTime? endDate;
  final List<String> days;
  final List<String> periods;
  final List<RecipeAllocation> recipeAllocations; // Changed to RecipeAllocation
  final List<String> trainees;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MealPlan({
    this.id,
    required this.name,
    required this.duration,
    this.startDate,
    this.endDate,
    List<String>? days,
    List<String>? periods,
    required this.recipeAllocations, // Changed to RecipeAllocation
    required this.trainees,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  })  : days = days ?? [],
        periods = periods ?? [];

  factory MealPlan.fromJson(Map<String, dynamic> json) {
    return MealPlan(
      id: json['_id'] as String?,
      name: json['name'] as String? ?? '',
      duration: json['duration'] as String? ?? '',
      startDate:
          json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      days: json['days'] != null ? List<String>.from(json['days']) : [],
      periods:
          json['periods'] != null ? List<String>.from(json['periods']) : [],
      recipeAllocations: json['recipeAllocations'] != null
          ? List<RecipeAllocation>.from(json['recipeAllocations']
              .map((item) => RecipeAllocation.fromJson(item)))
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
      'days': days,
      'periods': periods,
      'recipeAllocations': recipeAllocations.map((e) => e.toJson()).toList(),
      'trainees': trainees,
      'createdBy': createdBy,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MealPlan(id: $id, name: $name, duration: $duration, startDate: $startDate, endDate: $endDate, days: $days, periods: $periods, recipeAllocations: $recipeAllocations, trainees: $trainees, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
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
        listEquals(other.recipeAllocations, recipeAllocations) &&
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
        recipeAllocations.hashCode ^
        trainees.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
