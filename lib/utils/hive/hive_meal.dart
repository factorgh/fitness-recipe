import 'package:fit_cibus/utils/hive/hive_recurrence.dart';
import 'package:hive/hive.dart';

part 'hive_meal.g.dart';

@HiveType(typeId: 0)
class HiveMeal extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String mealType;

  @HiveField(2)
  final String timeOfDay;

  @HiveField(3)
  final List<String> recipes;

  @HiveField(4)
  final HiveRecurrence? recurrence;

  @HiveField(5)
  final DateTime? date;

  @HiveField(6)
  bool isDraft; // Draft status

  HiveMeal({
    this.id,
    required this.mealType,
    required this.recipes,
    required this.timeOfDay,
    required this.isDraft,
    this.recurrence,
    required this.date,
  });
  HiveMeal copyWith({
    String? mealType,
    String? timeOfDay,
    bool? isDraft,
    List<String>? recipes,
    HiveRecurrence? recurrence,
    DateTime? date,
  }) {
    return HiveMeal(
      mealType: mealType ?? this.mealType,
      timeOfDay: timeOfDay ?? this.timeOfDay,
      isDraft: isDraft ?? this.isDraft,
      recipes: recipes ?? this.recipes,
      recurrence: recurrence ?? this.recurrence,
      date: date ?? this.date,
    );
  }

  @override
  String toString() {
    return 'HiveMeal(id: $id, mealType: $mealType, timeOfDay: $timeOfDay, '
        'recipes: $recipes, '
        'recurrence: ${recurrence.toString()}, date: $date, isDraft: $isDraft)';
  }
}
