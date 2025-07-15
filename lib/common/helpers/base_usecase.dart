import 'package:wakili/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  /// Executes the use case. Returns an [Either] a [Failure] on error
  /// or the [Type] (or null if the operation is meant to return null on success).
  Future<Either<Failure, Type>> call(Params params);
}

/// Pass this when the usecase expects no parameters.
class NoParams extends Equatable {
  const NoParams(); // Added const constructor
  @override
  List<Object?> get props => [];
}
