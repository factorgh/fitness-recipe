import 'package:fpdart/fpdart.dart';

import 'package:voltican_fitness/Features/auth/domain/entities/user_entity.dart';
import 'package:voltican_fitness/Features/auth/domain/repositories/auth_repositories.dart';
import 'package:voltican_fitness/core/error/failure.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, User>> signUp({
    required String email,
    required String fullName,
    required String password,
    required String username,
  }) async {
    try {
      final userModel =
          await remoteDataSource.signup(fullName, username, password, email);
      return Right(userModel as User);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  }) async {
    try {
      final userModel = await remoteDataSource.login(username, password);
      return Right(userModel as User);
    } catch (e) {
      return Left(Failure(message: e.toString()));
    }
  }
}
