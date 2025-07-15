import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/exceptions.dart';
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
    if (error is ServerException) {
      // This is for exceptions originating from the server communication layer (e.g., HTTP 500, network issues)
      return ServerFailure(
          message: error.message ?? 'A server error occurred.');
    } else if (error is CacheException) {
      // This is for errors related to local caching operations
      return CacheFailure(message: 'Failed to access local cache.');
    } else if (error is DatabaseException) {
      // This is for errors specifically from database operations (e.g., SQLite, Hive)
      return GeneralFailure(message: 'A database error occurred.');
    } else if (error is ClientException) {
      // This is for errors originating from invalid client requests (e.g., HTTP 4xx errors)
      return ClientFailure(message: error.message);
    } else if (error is ServerError) {
      // If your API client directly throws a ServerError object, map its message.
      // This typically represents a structured error response from the API.
      return ServerFailure(message: error.getErrorMessage());
    } else if (error is Exception) {
      // A general catch-all for any other unhandled Dart Exception
      // It's good to be specific when possible, but this covers the rest.
      return GeneralFailure(
          message:
              'An unexpected application error occurred: ${error.toString()}');
    } else {
      // Fallback for anything that's not an Exception (should be rare)
      return GeneralFailure(
          message: 'An unknown error occurred: ${error.toString()}');
    }
  }
}
