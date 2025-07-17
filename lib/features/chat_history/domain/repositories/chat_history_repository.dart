// features/chat_history/domain/repositories/chat_history_repository.dart
import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

abstract class ChatHistoryRepository {
  Future<Either<Failure, String>> saveConversation({
    required ChatConversation conversation,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getConversations(
      String userId);
  Future<Either<Failure, Map<String, dynamic>?>> getConversationById(
      String conversationId);
  Future<Either<Failure, void>> deleteConversation(String conversationId);
}
