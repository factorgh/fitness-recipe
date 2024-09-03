import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/mealplan.dart';

@Entity()
class MealPlan {
  @Id()
  int id = 0;
  String name;
  String duration;
  DateTime? startDate;
  DateTime? endDate;
  String createdBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<String>? trainees;

  @Property(type: PropertyType.byteVector)
  List<DateTime>? datesArray; // Store dates as byte array

  @Backlink('mealPlan')
  final meals = ToMany<Meal>();

  MealPlan({
    required this.name,
    required this.duration,
    required this.createdBy,
    this.startDate,
    this.endDate,
    this.trainees,
    this.createdAt,
    this.updatedAt,
  });
}
