// domain/entities/user.dart
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final List<String> savedRecipes;
  final List<String> mealPlans;
  final List<String> following;

  const User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
  });

  @override
  List<Object?> get props =>
      [id, fullName, username, email, role, savedRecipes, mealPlans, following];
}
