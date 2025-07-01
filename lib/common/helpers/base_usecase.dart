import 'package:wakili/core/errors/failures.dart';
import 'package:equatable/equatable.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type?>> call(Params params);
}

// Pass this when the usecase expects no parameters
// e.g a call to get a list of shows
class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

String getImagePath(String categoryTitle) {
  switch (categoryTitle) {
    case 'Traffic Law':
      return 'assets/wp.png';
    case 'Criminal Law':
      return 'assets/wp.png';
    case 'Family Law':
      return 'assets/wp.png';
    case 'Employment':
      return 'assets/wp.png';
    case 'Property Law':
      return 'assets/wp.png';
    case 'Business Law':
      return 'assets/wp.png';
    case 'Consumer Rights':
      return 'assets/wp.png';
    case 'Constitutional':
      return 'assets/wp.png';
    default:
      return 'assets/wp.png';
  }
}
