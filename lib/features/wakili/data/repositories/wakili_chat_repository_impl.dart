import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/core/api_client/models/server_error.dart';
import 'package:wakili/features/wakili/data/datasources/wakili_chat_remote_datasource.dart';
import 'package:wakili/features/wakili/domain/repositories/wakili_chat_repository.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@LazySingleton(as: WakiliChatRepository)
class WakiliChatRepositoryImpl implements WakiliChatRepository {
  final WakiliChatRemoteDataSource _remoteDataSource;

  WakiliChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> sendMessage(
    String message, {
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      final response = await _remoteDataSource.sendMessage(
        message,
        conversationHistory: conversationHistory,
      );
      return right(response);
    } catch (e) {
      final failure = _mapErrorToFailure(e);
      return left(failure);
    }
  }

  @override
  Stream<Either<Failure, String>> sendMessageStream(
    String message, {
    List<ChatMessage>? conversationHistory,
  }) async* {
    try {
      await for (final chunk in _remoteDataSource.sendMessageStream(
        message,
        conversationHistory: conversationHistory,
      )) {
        yield right(chunk);
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
