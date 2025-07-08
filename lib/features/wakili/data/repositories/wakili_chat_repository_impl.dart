import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/core/api_client/models/server_error.dart';
import 'package:wakili/features/wakili/data/datasources/wakili_chat_remote_datasource.dart';
import 'package:wakili/features/wakili/domain/repositories/wakili_chat_repository.dart';

@LazySingleton(as: WakiliChatRepository)
class WakiliChatRepositoryImpl implements WakiliChatRepository {
  final WakiliChatRemoteDataSource _remoteDataSource;

  WakiliChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, NoParams>> sendMessage(String message) async {
    try {
      await _remoteDataSource.sendMessage(message);
      return right(NoParams());
    } catch (e) {
      final failure = _mapErrorToFailure(e);
      return left(failure);
    }
  }

  @override
  Stream<Either<Failure, NoParams>> sendMessageStream(String message) async* {
    try {
      await for (final _ in _remoteDataSource.sendMessageStream(message)) {
        yield right(NoParams());
      }
    } catch (e) {
      yield left(_mapErrorToFailure(e));
    }
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is ServerError) {
      return ServerFailure(badResponse: error);
    } else if (error is Exception) {
      return ServerFailure(badResponse: ServerError(message: error.toString()));
    } else {
      return GeneralFailure(error: 'Unexpected error: $error');
    }
  }
}
