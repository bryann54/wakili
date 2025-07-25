import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/core/api_client/models/server_error.dart';
import 'package:wakili/features/wakili/data/datasources/legal_category_remote_datasource.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/domain/repositories/legal_category_repository.dart';

@LazySingleton(as: LegalCategoryRepository)
class LegalCategoryRepositoryImpl implements LegalCategoryRepository {
  final LegalCategoryRemoteDataSource _remoteDataSource;

  LegalCategoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<LegalCategory>>> getLegalCategories() async {
    try {
      final categories = await _remoteDataSource.getLegalCategories();
      return right(categories);
    } catch (e) {
      return left(_mapErrorToFailure(e));
    }
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is ServerException) {
      return ServerFailure(
          message: error.message ?? 'A server error occurred.');
    } else if (error is CacheException) {
      return CacheFailure(message: 'Failed to access local cache.');
    } else if (error is DatabaseException) {
      return GeneralFailure(message: 'A database error occurred.');
    } else if (error is ClientException) {
      return ClientFailure(message: error.message);
    } else if (error is ServerError) {
      return ServerFailure(message: error.getErrorMessage());
    } else if (error is Exception) {
      return GeneralFailure(
          message:
              'An unexpected application error occurred: ${error.toString()}');
    } else {
      return GeneralFailure(
          message: 'An unknown error occurred: ${error.toString()}');
    }
  }
}
