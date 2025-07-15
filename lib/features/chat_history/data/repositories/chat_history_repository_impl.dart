import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/core/errors/exceptions.dart'; // Import exceptions
// No longer need ServerError directly here, as ServerFailure now takes a message
// import 'package:wakili/core/api_client/models/server_error.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';
import 'package:wakili/features/chat_history/data/datasources/chat_history_datasource.dart';

@LazySingleton(as: ChatHistoryRepository)
class ChatHistoryRepositoryImpl implements ChatHistoryRepository {
  final ChatHistoryLocalDataSource _localDataSource;

  ChatHistoryRepositoryImpl(this._localDataSource);

  @override
  Future<Either<Failure, List<ChatConversation>>> getChatHistory() async {
    try {
      final data = await _localDataSource.getChatHistory();
      return right(data);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> saveChatConversation(
      ChatConversation conversation) async {
    try {
      await _localDataSource.saveChatConversation(conversation);
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteChatConversation(
      String conversationId) async {
    try {
      await _localDataSource.deleteChatConversation(conversationId);
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateChatConversation(
      ChatConversation conversation) async {
    try {
      await _localDataSource.updateChatConversation(conversation);
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, Unit>> clearChatHistory() async {
    try {
      await _localDataSource.clearChatHistory();
      return right(unit);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  @override
  Future<Either<Failure, ChatConversation?>> searchChatHistory(
      ChatConversation conversation) async {
    try {
      final result = await _localDataSource.searchChatHistory(conversation);
      return right(result);
    } catch (e) {
      return left(_mapError(e));
    }
  }

  // Helper method to map exceptions to failures
  Failure _mapError(Object e) {
    if (e is ServerException) {
      // ServerException now has a message property
      return ServerFailure(message: e.message ?? 'Server error occurred.');
    } else if (e is CacheException) {
      // CacheException now has a message property
      return CacheFailure(message: 'Failed to access local cache.');
    } else if (e is DatabaseException) {
      // Added specific handling for DatabaseException
      return GeneralFailure(message: 'Database operation failed.');
    } else if (e is ClientException) {
      // ClientException carries a message
      return ClientFailure(message: e.message);
    } else {
      // Catch-all for any other unexpected exceptions
      return GeneralFailure(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }
}
