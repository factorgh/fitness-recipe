import 'dart:convert';

import 'package:voltican_fitness/models/recipe.dart';

class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String role;
  final String? imageUrl;
  final String password;
  final List<Recipe> savedRecipes;
  final List<String> mealPlans;
  final List<String> following;
  final List<String> followers;
  final String? code;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    required this.username,
    required this.role,
    this.imageUrl,
    required this.password,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
    this.followers = const [],
    this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? fullName,
    String? email,
    String? username,
    String? role,
    String? imageUrl,
    String? password,
    List<Recipe>? savedRecipes,
    List<String>? mealPlans,
    List<String>? following,
    List<String>? followers,
    String? code,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      username: username ?? this.username,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
      password: password ?? this.password,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      mealPlans: mealPlans ?? this.mealPlans,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

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
      followers: List<String>.from(json['followers'] ?? []),
      mealPlans: List<String>.from(json['mealPlans'] ?? []),
      code: json['code'] as String?,
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
      'followers': followers,
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, email: $email, username: $username, role: $role, imageUrl: $imageUrl, password: $password, savedRecipes: $savedRecipes, mealPlans: $mealPlans, following: $following, followers: $followers, code: $code, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
