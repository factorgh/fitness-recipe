class MealPlan {
  final String id;
  final String name;
  final String duration;
  final List<String> days;
  final List<MealPeriod> mealPeriods;
  final String createdBy;
  final List<String> assignedUsers;

  MealPlan({
    required this.id,
    required this.name,
    required this.duration,
    required this.days,
    required this.mealPeriods,
    required this.createdBy,
    required this.assignedUsers,
  });
}

class MealPeriod {
  final String period;
  final String time;
  final List<String> recipes;

  MealPeriod({
    required this.period,
    required this.time,
    required this.recipes,
  });
}
