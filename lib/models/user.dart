import 'dart:convert';

import 'package:voltican_fitness/models/recipe.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String role;
  final String imageUrl;
  final String password;

  final List<Recipe> savedRecipes;
  final List<String> mealPlans;
  final List<String> following;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.role,
    required this.imageUrl,
    required this.password,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      role: json['role'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      password: json['password'] as String? ?? '',
      savedRecipes: (json['savedRecipes'] as List<dynamic>?)
              ?.map((item) => Recipe.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      following: List<String>.from(json['following'] ?? []),
      mealPlans: List<String>.from(json['mealPlans'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'imageUrl': imageUrl,
      'role': role,
      'password': password,
      'savedRecipes': savedRecipes.map((recipe) => recipe.toString()).toList(),
      'mealPlans': mealPlans,
      'following': following,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, email: $email, username: $username, role: $role, imageUrl: $imageUrl, password: $password, savedRecipes: $savedRecipes, mealPlans: $mealPlans, following: $following, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
