// ignore_for_file: avoid_print

import 'package:fit_cibus/Features/trainer/trainer_service.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// State notifier for managing a list of followers with separate trainees and trainers
class FollowersNotifier
    extends StateNotifier<AsyncValue<Map<String, List<User>>>> {
  final TrainerService _trainerService;

  FollowersNotifier(this._trainerService) : super(const AsyncValue.loading());

  Future<void> fetchFollowers(String trainerId, String filter) async {
    try {
      final followers = await _trainerService.getFollowers(trainerId);

      // Filter followers based on the provided filter
      List<User> filteredFollowers;
      if (filter == 'Trainees') {
        filteredFollowers =
            followers.where((user) => user.role == '0').toList();
      } else if (filter == 'Trainers') {
        filteredFollowers =
            followers.where((user) => user.role == '1').toList();
      } else {
        filteredFollowers = followers;
      }

      // Split filtered followers into trainees and trainers
      final trainees =
          filteredFollowers.where((user) => user.role == '0').toList();
      final trainers =
          filteredFollowers.where((user) => user.role == '1').toList();

      // Update the state with separate lists
      state = AsyncValue.data({
        'trainees': trainees,
        'trainers': trainers,
      });
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to fetch followers: $e');
    }
  }

  Future<void> followTrainer(
      String trainerId, String trainerToFollowId, BuildContext context) async {
    try {
      await _trainerService.followTrainer(
          trainerId, trainerToFollowId, context);
      await fetchFollowers(
          trainerId, 'Followers'); // Refresh followers list with default filter
    } catch (e) {
      print('Failed to follow trainer: $e');
    }
  }

  Future<void> unfollowTrainer(
      String trainerId, String trainerToUnfollowId) async {
    try {
      await _trainerService.unfollowTrainer(trainerToUnfollowId);
      await fetchFollowers(
          trainerId, 'All'); // Refresh followers list with default filter
    } catch (e) {
      print('Failed to unfollow trainer: $e');
    }
  }

  Future<void> removeFollower(String trainerId, String followerId) async {
    try {
      // Optimistically update the state
      final currentTrainees = state.value?['trainees'] ?? [];
      final currentTrainers = state.value?['trainers'] ?? [];

      final updatedTrainees =
          currentTrainees.where((user) => user.id != followerId).toList();
      final updatedTrainers =
          currentTrainers.where((user) => user.id != followerId).toList();

      state = AsyncValue.data({
        'trainees': updatedTrainees,
        'trainers': updatedTrainers,
      });

      // Call the service to remove the follower
      await _trainerService.removeFollower(followerId);

      // Optionally refetch followers from the service if needed
      await fetchFollowers(trainerId, 'All');
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to remove follower: $e');
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

  Future<void> followTrainer(
      String trainerId, String trainerToFollowId, BuildContext context) async {
    try {
      await _trainerService.followTrainer(
          trainerId, trainerToFollowId, context);
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

  Future<void> removeFollowingTrainer(
      String trainerId, String trainerToRemoveId) async {
    try {
      // Optimistically update the state
      final currentFollowing = state.value ?? [];

      final updatedFollowing = currentFollowing
          .where((user) => user.id != trainerToRemoveId)
          .toList();
      state = AsyncValue.data(updatedFollowing);

      // Call the service to unfollow the trainer
      await _trainerService.unfollowTrainer(trainerToRemoveId);

      // Optionally refetch following trainers from the service if needed
      await fetchFollowingTrainers(trainerId);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      print('Failed to remove following trainer: $e');
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
    AsyncValue<Map<String, List<User>>>, String>((ref, trainerId) {
  final trainerService = ref.watch(trainerServiceProvider);
  final filter = ref.watch(trainerFilterProvider); // Get the current filter
  return FollowersNotifier(trainerService)..fetchFollowers(trainerId, filter);
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

// Traineee Provider
final traineeServiceProvider = Provider<TrainerService>((ref) {
  return TrainerService();
});

final traineeDetailsProvider =
    FutureProvider.family<List<User>, List<String>>((ref, traineeIds) async {
  final service = ref.watch(traineeServiceProvider);
  return await service.fetchTraineeDetails(traineeIds);
});

// Dropdown filter providers
final trainerFilterProvider = StateProvider<String>((ref) => 'All');
final traineeFilterProvider = StateProvider<String>((ref) => 'All');
