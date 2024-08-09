import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/auth/domain/entities/user_entity.dart';
import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:voltican_fitness/core/error/usecase/usecase.dart';

class CurrentUserUsecase implements UseCase<User, CurrentParams> {
  final AuthRepository authRepository;

  CurrentUserUsecase(this.authRepository);

  @override
  Future<Either<Failure, User>> call(CurrentParams params) async {
    return await authRepository.getCurrentUser(userId: params.userId);
  }
}

class CurrentParams {
  final String userId;
  CurrentParams(this.userId);
}
