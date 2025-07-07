import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/core/errors/exceptions.dart'; // Import exceptions
import 'package:wakili/core/api_client/models/server_error.dart';
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

  Failure _mapError(Object e) {
    if (e is ServerException) {
      // Assuming ServerException might carry a message that maps to ServerError
      return ServerFailure(
          badResponse:
              ServerError(message: e.message ?? 'Unknown server error'));
    } else if (e is CacheException) {
      return CacheFailure();
    } else if (e is ClientException) {
      return ClientFailure(error: e.message);
    } else if (e is ServerError) {
      // This is for direct ServerError thrown, if any
      return ServerFailure(badResponse: e);
    } else if (e is Exception) {
      // Catch-all for other unhandled exceptions
      return GeneralFailure(error: e.toString());
    } else {
      return GeneralFailure(error: 'Unexpected error: $e');
    }
  }
}
