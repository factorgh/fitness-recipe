import 'package:hive/hive.dart';
import 'package:voltican_fitness/models/recipe.dart';

part 'hive_recipe.g.dart';

@HiveType(typeId: 3)
class HiveRecipe extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final List<String> ingredients;

  @HiveField(3)
  final String instructions;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final String facts;

  @HiveField(6)
  final String status;

  @HiveField(7)
  final String period;

  @HiveField(8)
  final String imageUrl;

  @HiveField(9)
  final List<Rating>? ratings;

  @HiveField(10)
  final String createdBy;

  @HiveField(11)
  final DateTime createdAt;

  @HiveField(12)
  final DateTime updatedAt;

  HiveRecipe({
    this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.description,
    required this.facts,
    required this.status,
    required this.period,
    required this.imageUrl,
    this.ratings,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  // Override toString method for better readability
  @override
  String toString() {
    return 'HiveRecipe{id: $id, title: $title, ingredients: ${ingredients.join(", ")}, '
        'instructions: $instructions, description: $description, facts: $facts, '
        'status: $status, period: $period, imageUrl: $imageUrl, createdBy: $createdBy, '
        'createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
