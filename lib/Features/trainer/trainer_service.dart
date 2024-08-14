import 'package:voltican_fitness/classes/dio_client.dart';
import 'package:voltican_fitness/models/user.dart';

class TrainerService {
  final DioClient client = DioClient();

  Future<List<User>> getFollowers(String trainerId) async {
    try {
      final response = await client.dio.get('/users/$trainerId/followers');
      return (response.data as List)
          .map((followerData) => User.fromJson(followerData))
          .toList();
    } catch (e) {
      throw Exception('Failed to load followers');
    }
  }

  Future<List<User>> getFollowingTrainers(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/following');
      return (response.data as List)
          .map((followingData) => User.fromJson(followingData))
          .toList();
    } catch (e) {
      throw Exception('Failed to load following trainers');
    }
  }

  Future<List<User>> getTraineesFollowingTrainer(String trainerId) async {
    try {
      final response =
          await client.dio.get('/users/trainer/$trainerId/trainees');
      return (response.data as List)
          .map((followingData) => User.fromJson(followingData))
          .toList();
    } catch (e) {
      throw Exception('Failed to load following trainers');
    }
  }

  Future<void> followTrainer(String trainerId, String trainerToFollowId) async {
    try {
      await client.dio.post('/users/follow', data: {
        'userId': trainerId,
        'followId': trainerToFollowId,
      });
    } catch (e) {
      throw Exception('Failed to follow trainer');
    }
  }

  Future<void> unfollowTrainer(
      String trainerId, String trainerToUnfollowId) async {
    try {
      await client.dio.post('/users/unfollow', data: {
        'userId': trainerId,
        'unfollowId': trainerToUnfollowId,
      });
    } catch (e) {
      throw Exception('Failed to unfollow trainer');
    }
  }
}
