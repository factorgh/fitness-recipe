class Rating {
  final String userId;
  final int rating;

  Rating({required this.userId, required this.rating});
}

class Recipe {
  final String id;
  final String title;
  final List<String> ingredients;
  final String instructions;
  final String description;
  final String imageUrl;
  final String facts;
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

  double get averageRating {
    if (ratings.isEmpty) return 0;
    final sum = ratings.fold(0, (acc, rating) => acc + rating.rating);
    return sum / ratings.length;
  }
}
