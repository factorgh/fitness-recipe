import 'package:fit_cibus/Features/trainer/trainer_service.dart';
import 'package:fit_cibus/models/user.dart';
import 'package:fit_cibus/providers/trainer_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


// Provider for role "0" followers
class FollowersRole0Notifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;
  final String _trainerId;

  FollowersRole0Notifier(this._trainerService, this._trainerId)
      : super(const AsyncValue.loading()) {
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      final followers =
          await _trainerService.getFollowersByRole(_trainerId, "0");
      state = AsyncValue.data(followers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final followersRole0Provider = StateNotifierProvider.family<
    FollowersRole0Notifier, AsyncValue<List<User>>, String>((ref, trainerId) {
  final trainerService = ref.read(trainerServiceProvider);
  return FollowersRole0Notifier(trainerService, trainerId);
});

// Provider for role "1" followers
class FollowersRole1Notifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;
  final String _trainerId;

  FollowersRole1Notifier(this._trainerService, this._trainerId)
      : super(const AsyncValue.loading()) {
    fetchFollowers();
  }

  Future<void> fetchFollowers() async {
    try {
      final followers =
          await _trainerService.getFollowersByRole(_trainerId, "1");
      state = AsyncValue.data(followers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  Future<void> removeFollower(String followerId) async {
    try {
      await _trainerService.removeFollower(followerId);

      await fetchFollowers(); // Refresh followers list with default filter
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final followersRole1Provider = StateNotifierProvider.family<
    FollowersRole1Notifier, AsyncValue<List<User>>, String>((ref, trainerId) {
  final trainerService = ref.read(trainerServiceProvider);
  return FollowersRole1Notifier(trainerService, trainerId);
});
