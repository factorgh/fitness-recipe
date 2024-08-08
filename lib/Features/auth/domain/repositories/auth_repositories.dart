import "package:fpdart/fpdart.dart";
import 'package:voltican_fitness/Features/auth/domain/entities/user_entity.dart';

import "package:voltican_fitness/core/error/failure.dart";

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> login({
    required String username,
    required String password,
  });
  Future<Either<Failure, User>> getCurrentUser({
    required String userId,
  });
}
