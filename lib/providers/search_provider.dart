import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';

class SearchTrainersNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;

  SearchTrainersNotifier(this._trainerService)
      : super(const AsyncValue.loading());

  Future<void> searchTrainers(String query) async {
    try {
      final trainers = await _trainerService.searchTrainers(query);
      state = AsyncValue.data(trainers);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

class RequestNotifier extends StateNotifier<AsyncValue<void>> {
  final TrainerService _trainerService;

  RequestNotifier(this._trainerService) : super(const AsyncValue.data(null));

  Future<void> sendRequest(String traineeId, String trainerId) async {
    try {
      state = const AsyncValue.loading();
      await _trainerService.sendRequestToTrainer(traineeId, trainerId);
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final searchTrainersProvider =
    StateNotifierProvider<SearchTrainersNotifier, AsyncValue<List<User>>>(
        (ref) {
  final trainerService = ref.watch(trainerServiceProvider);
  return SearchTrainersNotifier(trainerService);
});

final requestProvider =
    StateNotifierProvider<RequestNotifier, AsyncValue<void>>((ref) {
  final trainerService = ref.watch(trainerServiceProvider);
  return RequestNotifier(trainerService);
});
