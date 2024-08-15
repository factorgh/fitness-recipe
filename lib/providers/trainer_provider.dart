// ignore_for_file: avoid_print

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/user.dart';

// State notifier for managing a list of followers
class FollowersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;

  FollowersNotifier(this._trainerService) : super(const AsyncValue.loading());

  Future<void> fetchFollowers(String trainerId) async {
    try {
      final followers = await _trainerService.getFollowers(trainerId);
      state = AsyncValue.data(followers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to fetch followers: $e');
    }
  }

  Future<void> followTrainer(String trainerId, String trainerToFollowId) async {
    try {
      await _trainerService.followTrainer(trainerId, trainerToFollowId);
      await fetchFollowers(trainerId); // Refresh followers list
    } catch (e) {
      print('Failed to follow trainer: $e');
    }
  }

  Future<void> unfollowTrainer(
      String trainerId, String trainerToUnfollowId) async {
    try {
      await _trainerService.unfollowTrainer(trainerToUnfollowId);
      await fetchFollowers(trainerId); // Refresh followers list
    } catch (e) {
      print('Failed to unfollow trainer: $e');
    }
  }
}

// State notifier for managing a list of following trainers
class FollowingTrainersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;

  FollowingTrainersNotifier(this._trainerService)
      : super(const AsyncValue.loading());

  Future<void> fetchFollowingTrainers(String trainerId) async {
    try {
      final followingTrainers =
          await _trainerService.getFollowingTrainers(trainerId);
      state = AsyncValue.data(followingTrainers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to fetch following trainers: $e');
    }
  }

  Future<void> followTrainer(String trainerId, String trainerToFollowId) async {
    try {
      await _trainerService.followTrainer(trainerId, trainerToFollowId);
      await fetchFollowingTrainers(
          trainerId); // Refresh following trainers list
    } catch (e) {
      print('Failed to follow trainer: $e');
    }
  }

  Future<void> unfollowTrainer(
      String trainerId, String trainerToUnfollowId) async {
    try {
      await _trainerService.unfollowTrainer(trainerToUnfollowId);
      await fetchFollowingTrainers(
          trainerId); // Refresh following trainers list
    } catch (e) {
      print('Failed to unfollow trainer: $e');
    }
  }
}

// State notifier for managing a list of trainees following the trainer
class TraineesFollowingNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;

  TraineesFollowingNotifier(this._trainerService)
      : super(const AsyncValue.loading());

  Future<void> fetchTraineesFollowingTrainer(String trainerId) async {
    try {
      final trainees =
          await _trainerService.getTraineesFollowingTrainer(trainerId);
      state = AsyncValue.data(trainees);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to fetch trainees: $e');
    }
  }
}

// Providers
final trainerServiceProvider = Provider<TrainerService>((ref) {
  return TrainerService();
});

final followersProvider = StateNotifierProvider.family<FollowersNotifier,
    AsyncValue<List<User>>, String>((ref, trainerId) {
  final trainerService = ref.watch(trainerServiceProvider);
  return FollowersNotifier(trainerService)..fetchFollowers(trainerId);
});

final followingTrainersProvider = StateNotifierProvider.family<
    FollowingTrainersNotifier,
    AsyncValue<List<User>>,
    String>((ref, trainerId) {
  final trainerService = ref.watch(trainerServiceProvider);
  return FollowingTrainersNotifier(trainerService)
    ..fetchFollowingTrainers(trainerId);
});

final traineesFollowingProvider = StateNotifierProvider.family<
    TraineesFollowingNotifier,
    AsyncValue<List<User>>,
    String>((ref, trainerId) {
  final trainerService = ref.watch(trainerServiceProvider);
  return TraineesFollowingNotifier(trainerService)
    ..fetchTraineesFollowingTrainer(trainerId);
});

// Dropdown filter providers
final trainerFilterProvider = StateProvider<String>((ref) => 'Followers');
final traineeFilterProvider = StateProvider<String>((ref) => 'All');
