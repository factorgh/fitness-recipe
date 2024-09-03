import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/meal.dart'; // Assuming this file contains the Meal class

@Entity()
class MealPlan {
  @Id()
  int id; // ObjectBox ID field

  final String name;
  final String duration;
  final DateTime? startDate;
  final DateTime? endDate;

  // DatesArray cannot be directly stored as List<DateTime>, consider serializing or handling separately
  @Transient() // Ignoring this field for ObjectBox
  final List<DateTime>? datesArray;

  // Define a One-to-Many relationship with Meal
  final ToMany<Meal> meals; // ObjectBox relationship

  final List<String> trainees;
  final String createdBy;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  MealPlan({
    this.id = 0, // Default ID
    required this.name,
    required this.duration,
    this.startDate,
    this.endDate,
    this.datesArray, // This will not be persisted directly in ObjectBox
    required this.trainees,
    required this.createdBy,
    this.createdAt,
    this.updatedAt,
  }) : meals = ToMany<Meal>(); // Initialize ToMany relationship
}
