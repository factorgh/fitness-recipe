// Meal Entity
import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/mealplan.dart';

@Entity()
class Meal {
  @Id()
  int id = 0;
  String mealType;
  String timeOfDay;
  DateTime date;

  final mealPlan = ToOne<MealPlan>();
  final recurrence = ToOne<Recurrence>();

  Meal({
    required this.mealType,
    required this.timeOfDay,
    required this.date,
  });
}
