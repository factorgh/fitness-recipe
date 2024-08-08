import 'package:voltican_fitness/Features/mealplan/domain/entities/mealplan.dart';

class MealPlanModel extends MealPlan {
  MealPlanModel({
    required super.id,
    required super.name,
    required super.duration,
    required super.days,
    required super.mealPeriods,
    required super.createdBy,
    required super.assignedUsers,
  });

  factory MealPlanModel.fromJson(Map<String, dynamic> json) {
    return MealPlanModel(
      id: json['_id'],
      name: json['name'],
      duration: json['duration'],
      days: List<String>.from(json['days']),
      mealPeriods: (json['mealPeriods'] as List)
          .map((e) => MealPeriod(
                period: e['period'],
                time: e['time'],
                recipes: List<String>.from(e['recipes']),
              ))
          .toList(),
      createdBy: json['createdBy'],
      assignedUsers: List<String>.from(json['assignedUsers']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'duration': duration,
      'days': days,
      'mealPeriods': mealPeriods
          .map((e) => {
                'period': e.period,
                'time': e.time,
                'recipes': e.recipes,
              })
          .toList(),
      'createdBy': createdBy,
      'assignedUsers': assignedUsers,
    };
  }
}
