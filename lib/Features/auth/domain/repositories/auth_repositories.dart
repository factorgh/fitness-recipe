import "package:fpdart/fpdart.dart";
import "package:voltican_fitness/core/error/failure.dart";

abstract interface class AuthRepository {
  Future<Either<Failure, String>> signUp({
    required String fullName,
    required String username,
    required String email,
    required String password,
  });
  Future<Either<Failure, String>> login({
    required String username,
    required String password,
  });
}
