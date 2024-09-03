import 'package:objectbox/objectbox.dart';

@Entity()
class Rating {
  @Id(assignable: true)
  int id;

  final String userId; // Reference to User
  final double rating;

  Rating({
    this.id = 0,
    required this.userId,
    required this.rating,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['user']['_id'] ?? '',
      rating: json['rating'] is int
          ? (json['rating'] as int).toDouble()
          : (json['rating'] as double),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'rating': rating,
    };
  }
}
