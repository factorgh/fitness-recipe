import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import 'package:voltican_fitness/core/error/usecase/usecase.dart';

class SignUpUseCase implements UseCase<String, UserSignUpParams> {
  final AuthRepository authRepository;

  SignUpUseCase(this.authRepository);
  @override
  Future<Either<Failure, String>> call(UserSignUpParams params) async {
    return await authRepository.signUp(
        fullName: params.fullName,
        username: params.username,
        email: params.email,
        password: params.password);
  }
}

class UserSignUpParams {
  final String fullName;
  final String username;
  final String email;
  final String password;
  UserSignUpParams({
    required this.fullName,
    required this.username,
    required this.email,
    required this.password,
  });
}
