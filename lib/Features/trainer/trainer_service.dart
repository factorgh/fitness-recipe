// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/utils/native_alert.dart';

class TrainerService {
  final DioClient client = DioClient();
  final alerts = NativeAlerts();

  Future<List<User>> getFollowers(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/followers');
      print('Followers response data: ${response.data}');
      return (response.data as List)
          .map((followerData) => User.fromJson(followerData))
          .toList();
    } catch (e) {
      print('Error in getFollowers: $e');
      throw Exception('Failed to load followers');
    }
  }

  Future<List<User>> getFollowingTrainers(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/following');
      print('Following trainers response data: ${response.data}');
      return (response.data as List)
          .map((followingData) => User.fromJson(followingData))
          .toList();
    } catch (e) {
      print('Error in getFollowingTrainers: $e');
      throw Exception('Failed to load following trainers');
    }
  }

  Future<List<User>> getTraineesFollowingTrainer(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/trainees');
      print('Trainees following response data: ${response.data}');
      return (response.data as List)
          .map((followingData) => User.fromJson(followingData))
          .toList();
    } catch (e) {
      print('Error in getTraineesFollowingTrainer: $e');
      throw Exception('Failed to load trainees following trainer');
    }
  }

  Future<void> followTrainer(
      String trainerId, String trainerToFollowId, BuildContext context) async {
    try {
      final res = await client.dio.post('/users/follow', data: {
        'currentUserId': trainerId,
        'userIdToFollow': trainerToFollowId,
      });
      if (res.statusCode == 200) {
        // Show success alert before navigating
        alerts.showSuccessAlert(context, 'User followed');
      } else {
        alerts.showErrorAlert(context, 'Already following user');
      }
    } catch (e) {
      alerts.showErrorAlert(context, 'Already following user');
      print('Error in followTrainer: $e');

      throw Exception('Failed to follow trainer');
    }
  }

  Future<void> unfollowTrainer(String trainerToUnfollowId) async {
    print(trainerToUnfollowId);
    try {
      final res = await client.dio.post('/users/unfollow', data: {
        'userIdToUnfollow': trainerToUnfollowId,
      });

      if (res.statusCode == 200) {
        print('Trainer unfollowed successfully');
      } else {
        print('Failed to unfollow trainer');
      }
    } catch (e) {
      print('Error in unfollowTrainer: $e');
      throw Exception('Failed to unfollow trainer');
    }
  }

  Future<List<User>> searchTrainers(String query) async {
    try {
      final response = await client.dio.get(
        '/users/trainers/search',
        queryParameters: {'query': query},
      );

      // Decode the response data if it's a string
      final responseData = response.data is String
          ? json.decode(response.data) // Decode JSON string to a List
          : response.data;

      // Print the type and contents of responseData for debugging
      print('Response Data Type: ${responseData.runtimeType}');
      print('Response Data: $responseData');

      if (responseData is List) {
        return responseData.map((trainerData) {
          // Print the type and contents of each trainerData for debugging
          print('Trainer Data Type: ${trainerData.runtimeType}');
          print('Trainer Data: $trainerData');
          return User.fromJson(trainerData);
        }).toList();
      } else {
        throw Exception(
            'Unexpected response format: ${responseData.runtimeType}');
      }
    } catch (e, stackTrace) {
      // Print the error and stack trace for debugging
      print('Error searching trainers: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Failed to search trainers');
    }
  }

  Future<void> sendRequestToTrainer(String traineeId, String trainerId) async {
    try {
      await client.dio
          .post('/trainers/$trainerId/request', data: {'traineeId': traineeId});
    } catch (e) {
      throw Exception('Failed to send request');
    }
  }

  Future<List<User>> fetchTraineeDetails(List<String> traineeIds) async {
    try {
      final response =
          await client.dio.get('/users/mealplan/trainees/details', data: {
        'traineeIds': traineeIds,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data['trainees'];
        return data.map((json) => User.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load trainee details');
      }
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      throw Exception('Dio error: ${e.message}');
    } catch (e) {
      // Handle general exceptions
      throw Exception('Unexpected error: $e');
    }
  }

  Future<List<User>> getFollowersByRole(String trainerId, String role) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/followers/$role');

      if (response.statusCode == 200) {
        // Assuming the response data is a list of followers
        final List<dynamic> data = response.data;
        return data.map((userData) => User.fromJson(userData)).toList();
      } else {
        throw Exception('Failed to load followers');
      }
    } catch (e) {
      // Handle other errors here
      print('Error in getFollowersByRole: $e');
      throw Exception('Failed to load followers');
    }
  }

  Future<List<User>> getAssignedTrainees(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/meal-plans/trainees/assigned-trainees');

      if (response.statusCode == 200) {
        return (response.data as List)
            .map((traineeData) => User.fromJson(traineeData))
            .toList();
      } else {
        throw Exception('Failed to load assigned trainees');
      }
    } catch (e) {
      print('Error in getAssignedTrainees: $e');
      throw Exception('Failed to load assigned trainees');
    }
  }

  Future<void> removeFollower(String followerId) async {
    try {
      final response = await client.dio.delete(
        '/users/user/followers/$followerId',
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to remove follower');
      }
    } catch (e) {
      print('Error in removeFollower: $e');
      throw Exception('Failed to remove follower');
    }
  }
}
