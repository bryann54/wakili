import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

abstract class ChatHistoryRepository {
  Future<Either<Failure, String>> saveConversation({
    required String userId,
    required String category,
    required List<ChatMessage> messages,
    String? conversationId,
  });
  Future<Either<Failure, List<Map<String, dynamic>>>> getConversations(
      String userId);
  Future<Either<Failure, Map<String, dynamic>?>> getConversationById(
      String conversationId);
  Future<Either<Failure, void>> deleteConversation(String conversationId);
}
