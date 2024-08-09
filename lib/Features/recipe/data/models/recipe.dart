import 'package:equatable/equatable.dart';

class RatingModel extends Equatable {
  final String userId;
  final int rating;

  const RatingModel({required this.userId, required this.rating});

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      userId: json['user'] as String,
      rating: json['rating'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': userId,
      'rating': rating,
    };
  }

  @override
  List<Object?> get props => [userId, rating];
}

class RecipeModel extends Equatable {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String description;
  final String facts;
  final String imageUrl;
  final List<RatingModel> ratings;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  const RecipeModel({
    required this.id,
    required this.title,
    required this.ingredients,
    required this.instructions,
    required this.description,
    required this.facts,
    required this.imageUrl,
    required this.ratings,
    required this.createdBy,
    required this.createdAt,
    required this.updatedAt,
  });

  factory RecipeModel.fromJson(Map<String, dynamic> json) {
    return RecipeModel(
      id: json['_id'] as String,
      title: json['title'] as String,
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'] as String,
      description: json['description'] as String,
      facts: json['facts'] as String,
      imageUrl: json['imageUrl'] as String,
      ratings: (json['ratings'] as List<dynamic>)
          .map((rating) => RatingModel.fromJson(rating as Map<String, dynamic>))
          .toList(),
      createdBy: json['createdBy'] as String,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'title': title,
      'ingredients': ingredients,
      'instructions': instructions,
      'description': description,
      'facts': facts,
      'imageUrl': imageUrl,
      'ratings': ratings.map((rating) => rating.toJson()).toList(),
      'createdBy': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        ingredients,
        instructions,
        description,
        facts,
        imageUrl,
        ratings,
        createdBy,
        createdAt,
        updatedAt,
      ];
}
