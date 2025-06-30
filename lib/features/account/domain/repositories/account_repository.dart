import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class AccountRepository {
  Future<Either<Failure, NoParams>> changeLanguage(String languageCode);
}
