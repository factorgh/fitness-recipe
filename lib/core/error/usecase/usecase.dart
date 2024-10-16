import 'package:fit_cibus/core/error/failure.dart';
import 'package:fpdart/fpdart.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
