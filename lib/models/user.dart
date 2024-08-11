import 'dart:convert';

class User {
  final String id;
  final String fullName;
  final String email;
  final String username;
  final String role;
  final String imageUrl;
  final String password;
  final String token;
  final List<String> savedRecipes;
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
    required this.token,
    required this.password,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'fullName': fullName,
      'email': email,
      'username': username,
      'role': role,
      'token': token,
      'password': password,
      'savedRecipes': savedRecipes,
      'mealPlans': mealPlans,
      'following': following,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
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
      savedRecipes: List<String>.from(json['savedRecipes'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      mealPlans: List<String>.from(json['mealPlans'] ?? []),
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : DateTime.now(),
      token: json['token'] as String? ?? '',
    );
  }

  @override
  String toString() {
    return 'User{id: $id, fullName: $fullName, email: $email, username: $username, role: $role, imageUrl: $imageUrl, token: $token, savedRecipes: $savedRecipes, mealPlans: $mealPlans, following: $following, createdAt: $createdAt, updatedAt: $updatedAt}';
  }

  String toJson() => json.encode(toMap());
}
