import 'package:fpdart/fpdart.dart';
import 'package:voltican_fitness/core/error/failure.dart';

abstract class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}
