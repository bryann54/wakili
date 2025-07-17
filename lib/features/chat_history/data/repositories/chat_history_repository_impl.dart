import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/data/datasources/chat_history_remote_datasource.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@LazySingleton(as: ChatHistoryRepository)
class ChatHistoryRepositoryImpl implements ChatHistoryRepository {
  final ChatHistoryRemoteDataSource _remoteDataSource;

  ChatHistoryRepositoryImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, String>> saveConversation({
    required String userId,
    required String category,
    required List<ChatMessage> messages,
    String? conversationId,
  }) async {
    try {
      final result = await _remoteDataSource.saveConversation(
        userId: userId,
        category: category,
        messages: messages,
        conversationId: conversationId,
      );
      return right(result);
    } catch (e) {
      return left(_mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> getConversations(
      String userId) async {
    try {
      final result = await _remoteDataSource.getConversations(userId);
      return right(result);
    } catch (e) {
      return left(_mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, Map<String, dynamic>?>> getConversationById(
      String conversationId) async {
    try {
      final result =
          await _remoteDataSource.getConversationById(conversationId);
      return right(result);
    } catch (e) {
      return left(_mapErrorToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> deleteConversation(
      String conversationId) async {
    try {
      await _remoteDataSource.deleteConversation(conversationId);
      return right(unit);
    } catch (e) {
      return left(_mapErrorToFailure(e));
    }
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Exception) {
      return GeneralFailure(message: 'Chat history error: ${error.toString()}');
    }
    return GeneralFailure(
        message: 'An unknown error occurred with chat history.');
  }
}
