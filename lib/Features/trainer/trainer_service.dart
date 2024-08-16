// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/user.dart';

class TrainerService {
  final DioClient client = DioClient();

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

  Future<void> followTrainer(String trainerId, String trainerToFollowId) async {
    try {
      await client.dio.post('/users/follow', data: {
        'userId': trainerId,
        'followId': trainerToFollowId,
      });
    } catch (e) {
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
}
