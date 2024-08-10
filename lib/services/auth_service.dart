// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/commons/constants/error_handling.dart';
import 'package:voltican_fitness/models%202/user.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/role_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';

class AuthService {
  final DioClient client = DioClient();

  void signup({
    required BuildContext context,
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    User user = User(
        id: "",
        fullName: fullName,
        email: email,
        username: username,
        role: '0',
        token: '',
        imageUrl: "",
        password: password,
        savedRecipes: [],
        following: [],
        mealPlans: [],
        createdAt: DateTime.now(),
        updatedAt: DateTime.now());
    dio.Response res = await client.dio.post(
      "/users/register",
      data: user.toJson(),
    );

    httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnack(context, 'Account created successfully');

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const RoleScreen(),
            ),
          );
        });
  }

// SignInUser
  Future<void> signIn({
    required BuildContext context,
    required WidgetRef ref, // Add WidgetRef to access Riverpod
    required String username,
    required String password,
  }) async {
    dio.Response res = await client.dio.post(
      "/users/login",
      data: {
        'username': username,
        'password': password,
      },
    );

    // Handle the response
    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        // Extract user data from the response
        // final data = res.data['user'];
        final token = res.data['token'];

        // // Create a User object from the response data
        // User user = User(
        //   id: data['_id'],
        //   fullName: data['fullName'],
        //   email: data['email'],
        //   username: data['username'],
        //   role: data['role'],
        //   imageUrl: data['imageUrl'],
        //   password:
        //       password, // Usually, you'd want to hash this or handle it differently
        //   savedRecipes: List<String>.from(data['savedRecipes']),
        //   following: List<String>.from(data['following']),
        //   mealPlans: List<String>.from(data['mealPlans']),
        //   createdAt: DateTime.parse(data['createdAt']),
        //   updatedAt: DateTime.parse(data['updatedAt']),
        //   token: token,
        // );

        // Store the token in SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        // Optionally navigate to another screen or show a success message
        showSnack(context, 'Signed in successfully');
        // Navigate user to home screen

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => const TabsScreen(userRole: 1),
          ),
        );
      },
    );
  }

// Get user using token

  void getMe({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    dio.Response res = await client.dio.get(
      "/users/me",
    );

    // Convert the response data to a User object

    // Now pass the User object to your provider
    ref.read(userProvider.notifier).setUser(res.data);
  }
}
