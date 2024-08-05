// data/repositories/auth_repository_impl.dart
import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/core/error/failure.dart';

import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, String>> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final token =
          await remoteDataSource.signup(fullName, username, password, email);
      return Right(token as String);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> login({
    required String username,
    required String password,
  }) async {
    try {
      final token = await remoteDataSource.login(
        username,
        password,
      );
      return Right(token as String);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
