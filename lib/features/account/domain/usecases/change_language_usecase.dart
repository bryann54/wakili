import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/account/domain/repositories/account_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ChangeLanguageUsecase implements UseCase<NoParams, String> {
  final AccountRepository _repo;

  ChangeLanguageUsecase(this._repo);

  @override
  Future<Either<Failure, NoParams>> call(String params) async {
    return await _repo.changeLanguage(params);
  }
}
