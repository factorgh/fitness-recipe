class Rating {
  final String userId;
  final int rating;

  Rating({
    required this.userId,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
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
}

class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String description;
  final String facts;
  final String imageUrl;
  final List<Rating> ratings;
  final String createdBy;
  final DateTime createdAt;
  final DateTime updatedAt;

  Recipe({
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

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['_id'] as String,
      title: json['title'] as String,
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'] as String,
      description: json['description'] as String,
      facts: json['facts'] as String,
      imageUrl: json['imageUrl'] as String,
      ratings: (json['ratings'] as List)
          .map((rating) => Rating.fromJson(rating))
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

  double get averageRating {
    if (ratings.isEmpty) return 0;
    final sum = ratings.map((rating) => rating.rating).reduce((a, b) => a + b);
    return sum / ratings.length;
  }
}
