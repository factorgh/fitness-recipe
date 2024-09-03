import 'package:objectbox/objectbox.dart';

@Entity()
class Recurrence {
  @Id()
  int id = 0;
  String? option;
  DateTime? date;
  List<String>? exceptions;
  List<DateTime>? customDates;
  List<int>? customDays;

  Recurrence({
    this.option,
    this.date,
    this.exceptions,
    this.customDates,
    this.customDays,
  });
}
