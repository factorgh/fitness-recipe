// ignore_for_file: avoid_print

import 'package:fit_cibus/models/user.dart';
import 'package:flutter/foundation.dart';

class Rating {
  final User user;
  final double rating;

  Rating({
    required this.user,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    final userJson = json['user'] as Map<String, dynamic>?;
    final ratingValue = json['rating'];

    // Handle case where rating can be either int or double
    final rating = ratingValue is int
        ? ratingValue.toDouble()
        : ratingValue as double? ?? 0.0;

    return Rating(
      user: userJson != null ? User.fromJson(userJson) : User.empty,
      rating: rating,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user': user.toJson(),
      'rating': rating,
    };
  }
}

class Recipe {
  final String? id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String description;
  final String facts;
  final String status;
  final String period;
  final String imageUrl;
  final List<Rating>? ratings;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
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
  factory Recipe.fromJson(Map<String, dynamic> json) {
    print('JSON received: $json');
    print('ID: ${json['_id']}'); // Debug the _id specifically

    return Recipe(
      id: json['_id']?.toString(),
      title: json['title'] as String? ?? '',
      ingredients: List<String>.from(json['ingredients'] ?? []),
      instructions: json['instructions'] as String? ?? '',
      description: json['description'] as String? ?? '',
      facts: json['facts'] as String? ?? '',
      status: json['status'] as String? ?? '',
      period: json['period'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      ratings: (json['ratings'] as List? ?? [])
          .map((rating) => Rating.fromJson(rating))
          .toList(),
      createdBy: json['createdBy'] as String? ?? '',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ??
          DateTime.now(),
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
      'status': status,
      'period': period,
      'imageUrl': imageUrl,
      'ratings': ratings?.map((rating) => rating.toJson()).toList() ?? [],
      'createdBy': createdBy,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  double get averageRating {
    if (ratings == null || ratings!.isEmpty) return 0;
    final sum = ratings!.map((rating) => rating.rating).reduce((a, b) => a + b);
    return sum / ratings!.length;
  }

  factory Recipe.fromMap(Map<String, dynamic> map) {
    return Recipe.fromJson(map);
  }

  @override
  String toString() {
    return 'Recipe(id: $id, title: $title, ingredients: $ingredients, instructions: $instructions, description: $description, facts: $facts, period: $period, imageUrl: $imageUrl, ratings: $ratings, createdBy: $createdBy, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Recipe other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.title == title &&
        listEquals(other.ingredients, ingredients) &&
        other.instructions == instructions &&
        other.description == description &&
        other.facts == facts &&
        other.status == status &&
        other.period == period &&
        other.imageUrl == imageUrl &&
        listEquals(other.ratings, ratings) &&
        other.createdBy == createdBy &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        title.hashCode ^
        ingredients.hashCode ^
        instructions.hashCode ^
        description.hashCode ^
        facts.hashCode ^
        status.hashCode ^
        period.hashCode ^
        imageUrl.hashCode ^
        ratings.hashCode ^
        createdBy.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
