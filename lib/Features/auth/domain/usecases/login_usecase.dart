import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/auth/domain/entities/user_entity.dart';

import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:voltican_fitness/core/error/usecase/usecase.dart';

class LoginUseCase implements UseCase<String, UserLoginParams> {
  final AuthRepository authRepository;

  LoginUseCase(this.authRepository);
  @override
  Future<Either<Failure, User>> call(UserLoginParams params) async {
    print('-------------- details -------------');
    print(params.username);

    return await authRepository.login(
        username: params.username, password: params.password);
  }
}

class UserLoginParams {
  final String username;
  final String password;
  UserLoginParams({
    required this.username,
    required this.password,
  });
}
