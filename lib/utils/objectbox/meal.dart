import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/mealplan.dart';
import 'package:voltican_fitness/utils/objectbox/recipe.dart';

@Entity()
class Meal {
  @Id()
  int id; // ObjectBox ID field

  final String mealType;
  final String timeOfDay;
  final Recurrence? recurrence; // Assuming Recurrence is defined elsewhere
  final DateTime date;

  // Define recipes as a relationship (ToMany)
  final recipes =
      ToMany<Recipe>(); // Recipes refers to a list of Recipe objects.

  Meal({
    this.id = 0, // Default ID is 0, it will be set by ObjectBox
    required this.mealType,
    required this.timeOfDay,
    this.recurrence,
    required this.date,
  });
}
