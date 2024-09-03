import 'package:hive/hive.dart';

part 'recurrence.g.dart';

@HiveType(typeId: 0)
class Recurrence {
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

  Recurrence({
    required this.option,
    required this.date,
    this.customDates,
    this.exceptions,
    this.customDays,
  });
}
