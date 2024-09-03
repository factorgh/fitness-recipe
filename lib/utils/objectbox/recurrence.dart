import 'package:objectbox/objectbox.dart';

@Entity()
class Recurrence {
  @Id()
  int id; // Add an ID field for ObjectBox

  final String option;
  final DateTime date;
  final List<DateTime>? exceptions;
  final List<DateTime>? customDates;
  final List<int>? customDays;

  Recurrence({
    this.id = 0,
    required this.option,
    required this.date,
    this.customDates,
    this.exceptions,
    this.customDays,
  });
}
