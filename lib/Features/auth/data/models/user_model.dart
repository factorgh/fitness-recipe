// data/models/user_model.dart
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String id;
  final String fullName;
  final String username;
  final String email;
  final String role;
  final List<String> savedRecipes;
  final List<String> mealPlans;
  final List<String> following;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.username,
    required this.email,
    required this.role,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id'],
      fullName: json['fullName'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      savedRecipes: List<String>.from(json['savedRecipes']),
      mealPlans: List<String>.from(json['mealPlans']),
      following: List<String>.from(json['following']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'username': username,
      'email': email,
      'role': role,
      'savedRecipes': savedRecipes,
      'mealPlans': mealPlans,
      'following': following,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        username,
        email,
        role,
        savedRecipes,
        mealPlans,
        following,
        createdAt,
        updatedAt
      ];
}
