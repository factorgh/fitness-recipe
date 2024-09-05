import 'package:hive/hive.dart';

part 'rating.g.dart';

@HiveType(typeId: 4)
class Rating extends HiveObject {
  @HiveField(0)
  final String user;

  @HiveField(1)
  final double rating;

  Rating({
    required this.user,
    required this.rating,
  });
}
