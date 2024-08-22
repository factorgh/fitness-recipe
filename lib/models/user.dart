import 'package:flutter/foundation.dart';

class User {
  final String id;
  final String fullName;
  final String username;
  final String password;
  final String email;
  final String? imageUrl;
  final String role;
  final List<String> savedRecipes;
  final List<String> mealPlans;
  final List<String> following;
  final List<String> followers;
  final String? code;
  final DateTime createdAt;
  final DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.username,
    required this.password,
    required this.email,
    this.imageUrl,
    required this.role,
    required this.savedRecipes,
    required this.mealPlans,
    required this.following,
    required this.followers,
    this.code,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['_id'] as String? ?? '',
      fullName: json['fullName'] as String? ?? '',
      username: json['username'] as String? ?? '',
      password: json['password'] as String? ?? '',
      email: json['email'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      role: json['role'] as String? ?? '',
      savedRecipes: List<String>.from(json['savedRecipes'] ?? []),
      mealPlans: List<String>.from(json['mealPlans'] ?? []),
      following: List<String>.from(json['following'] ?? []),
      followers: List<String>.from(json['followers'] ?? []),
      code: json['code'] as String?,
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'fullName': fullName,
      'username': username,
      'password': password,
      'email': email,
      'imageUrl': imageUrl,
      'role': role,
      'savedRecipes': savedRecipes,
      'mealPlans': mealPlans,
      'following': following,
      'followers': followers,
      'code': code,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? fullName,
    String? username,
    String? password,
    String? email,
    String? imageUrl,
    String? role,
    List<String>? savedRecipes,
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
      username: username ?? this.username,
      password: password ?? this.password,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
      savedRecipes: savedRecipes ?? this.savedRecipes,
      mealPlans: mealPlans ?? this.mealPlans,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      code: code ?? this.code,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static User get empty => User(
        id: '',
        fullName: '',
        username: '',
        password: '',
        email: '',
        imageUrl: null,
        role: '',
        savedRecipes: [],
        mealPlans: [],
        following: [],
        followers: [],
        code: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

  @override
  String toString() {
    return 'User(id: $id, fullName: $fullName, username: $username, password: $password, email: $email, imageUrl: $imageUrl, role: $role, savedRecipes: $savedRecipes, mealPlans: $mealPlans, following: $following, followers: $followers, code: $code, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant User other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.fullName == fullName &&
        other.username == username &&
        other.password == password &&
        other.email == email &&
        other.imageUrl == imageUrl &&
        other.role == role &&
        listEquals(other.savedRecipes, savedRecipes) &&
        listEquals(other.mealPlans, mealPlans) &&
        listEquals(other.following, following) &&
        listEquals(other.followers, followers) &&
        other.code == code &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        fullName.hashCode ^
        username.hashCode ^
        password.hashCode ^
        email.hashCode ^
        imageUrl.hashCode ^
        role.hashCode ^
        savedRecipes.hashCode ^
        mealPlans.hashCode ^
        following.hashCode ^
        followers.hashCode ^
        code.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
