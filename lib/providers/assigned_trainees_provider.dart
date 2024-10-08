import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voltican_fitness/Features/trainer/trainer_service.dart';
import 'package:voltican_fitness/models/user.dart';
import 'package:voltican_fitness/providers/trainer_provider.dart';

class AssignedTraineesNotifier extends StateNotifier<AsyncValue<List<User>>> {
  final TrainerService _trainerService;
  final String _trainerId;

  AssignedTraineesNotifier(this._trainerService, this._trainerId)
      : super(const AsyncValue.loading()) {
    fetchAssignedTrainees();
  }

  Future<void> fetchAssignedTrainees() async {
    try {
      final trainees = await _trainerService.getAssignedTrainees(_trainerId);
      state = AsyncValue.data(trainees);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final assignedTraineesProvider = StateNotifierProvider.family<
    AssignedTraineesNotifier, AsyncValue<List<User>>, String>((ref, trainerId) {
  final trainerService = ref.read(trainerServiceProvider);
  return AssignedTraineesNotifier(trainerService, trainerId);
});
