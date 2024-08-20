// ignore_for_file: use_build_context_synchronously, avoid_print

import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/commons/constants/error_handling.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/user_provider.dart';
import 'package:voltican_fitness/screens/role_screen.dart';
import 'package:voltican_fitness/screens/tabs_screen.dart';
import 'package:voltican_fitness/utils/show_snackbar.dart';

class AuthService {
  final DioClient client = DioClient();

  Future<void> signup({
    required BuildContext context,
    required String fullName,
    required String username,
    required String email,
    required String password,
    required WidgetRef ref,
  }) async {
    User user = User(
        id: "",
        fullName: fullName,
        email: email,
        username: username,
        role: '0',
        password: password,
        imageUrl: "",
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
        onSuccess: () async {
          final token = res.data['token'];
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);

          showSnack(context, 'Account created successfully');

          //  Get role from user
          ref.read(userProvider.notifier).setUser(res.data.user);

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (ctx) => const RoleScreen(),
            ),
          );
        });
  }

  Future<void> signIn({
    required BuildContext context,
    required WidgetRef ref,
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

    httpErrorHandle(
      response: res,
      context: context,
      onSuccess: () async {
        final token = res.data['token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('auth_token', token);

        showSnack(context, 'Signed in successfully');

        // Map response data to User model
        User user = User.fromJson(res.data['user']);
        ref.read(userProvider.notifier).setUser(user);

        // Get role from user
        final userRole = res.data['user']['role'];

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (ctx) => TabsScreen(userRole: userRole),
          ),
        );
      },
    );
  }

  Future<void> getMe({
    required BuildContext context,
    required WidgetRef ref,
  }) async {
    try {
      dio.Response res = await client.dio.get(
        "/users/me",
      );

      User user = User.fromJson(res.data);

      ref.read(userProvider.notifier).setUser(user);
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }

  Future<void> updateUser({
    required BuildContext context,
    required WidgetRef ref,
    required String id,
    required String fullName,
    required String username,
    required String email,
  }) async {
    try {
      dio.Response res = await client.dio.put(
        "/users/$id",
        data: {
          'fullName': fullName,
          'username': username,
          'email': email,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Update the user in the state after a successful update
          ref.read(userProvider.notifier).updateUser(
                fullName: fullName,
                username: username,
                email: email,
              );

          showSnack(context, 'User updated successfully');
        },
      );
    } catch (e) {
      print('Error updating user: $e');
      showSnack(context, 'Failed to update user');
    }
  }

  Future<void> deleteUser({
    required BuildContext context,
    required String id,
  }) async {
    try {
      dio.Response res = await client.dio.delete(
        "/users/$id",
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnack(context, 'User deleted successfully');
        },
      );
    } catch (e) {
      print('Error deleting user: $e');
      showSnack(context, 'Failed to delete user');
    }
  }

  Future<void> updateRole({
    required BuildContext context,
    required String role,
  }) async {
    try {
      dio.Response res = await client.dio.put(
        "/users/user/role",
        data: {
          'role': role,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Update the user in the state after a successful update

          showSnack(context, 'Role updated successfully');
        },
      );
    } catch (e) {
      print('Error updating user: $e');
      showSnack(context, 'Failed to update user');
    }
  }

  Future<void> updateImage({
    required BuildContext context,
    required String imageUrl,
    required String id,
  }) async {
    try {
      dio.Response res = await client.dio.put(
        "/users/$id",
        data: {
          'imageUrl': imageUrl,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Update the user in the state after a successful update

          showSnack(context, 'Profile image updated !');
        },
      );
    } catch (e) {
      print('Error updating user: $e');
      showSnack(context, 'Failed to update user');
    }
  }

  Future<Map<String, dynamic>?> getUserByCode(String code) async {
    try {
      final response = await client.dio
          .get('/trainer/code/$code/follow'); // Adjust the endpoint as needed

      if (response.statusCode == 200) {
        // Return the user data from the response
        return response.data['user'];
      } else {
        // Handle non-200 responses
        print('Failed to load user: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Handle exceptions
      print('Error fetching user by code: $e');
      return null;
    }
  }

  // Get top trainers
  Future<void> getTopTrainers({
    required BuildContext context,
    required Function(List<dynamic>) onSuccess,
  }) async {
    try {
      final res = await client.dio.get('/users/trainers/top-rated-trainers');

      if (res.statusCode == 200) {
        List<dynamic> trainers = res.data;
        print('Top trainers: $trainers');
        onSuccess(trainers);
      } else {
        // Handle server errors or unexpected responses
        showSnack(context, 'Failed to fetch top trainers');
      }
    } catch (e) {
      print('Error fetching top trainers: $e');
      showSnack(context, 'Failed to fetch top trainers');
    }
  }
}
