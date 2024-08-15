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
}
