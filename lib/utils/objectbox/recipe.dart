import 'package:objectbox/objectbox.dart';
import 'package:voltican_fitness/models/recipe.dart';

@Entity()
class Recipe {
  @Id(assignable: true)
  int id; // ObjectBox uses integer IDs
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String description;
  final String facts;
  final String status;
  final String period;
  final String imageUrl;

  @Property(type: PropertyType.date) // Store dates as timestamps
  final DateTime createdAt;

  @Property(type: PropertyType.date)
  final DateTime updatedAt;

  final String createdBy;

  // Relationship to Rating
  final ratings = ToMany<Rating>();

  Recipe({
    this.id = 0,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.description,
    required this.facts,
    required this.status,
    required this.period,
    required this.imageUrl,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id']?.toString() != null ? int.parse(json['_id']) : 0,
      title: json['title'] ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] ?? '',
      description: json['description'] ?? '',
      facts: json['facts'] ?? '',
      status: json['status'] ?? '',
      period: json['period'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      createdBy: json['createdBy'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id.toString(),
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'description': description,
      'facts': facts,
      'status': status,
      'period': period,
      'imageUrl': imageUrl,
      'createdBy': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}
