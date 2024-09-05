import 'package:hive/hive.dart';

part 'hive_recurrence.g.dart';

@HiveType(typeId: 2)
class HiveRecurrence {
  @HiveField(0)
  final String option;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final List<DateTime>? exceptions;

  @HiveField(3)
  final List<DateTime>? customDates;

  @HiveField(4)
  final List<int>? customDays;

  HiveRecurrence({
    required this.option,
    required this.date,
    this.customDates,
    this.exceptions,
    this.customDays,
  });
}
