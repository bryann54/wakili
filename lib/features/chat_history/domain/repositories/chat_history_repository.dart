import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

abstract class ChatHistoryRepository {
  Future<Either<Failure, List<ChatConversation>>> getChatHistory();
  Future<Either<Failure, Unit>> saveChatConversation(
      ChatConversation conversation);
  Future<Either<Failure, Unit>> deleteChatConversation(String conversationId);
  Future<Either<Failure, Unit>> updateChatConversation(
      ChatConversation conversation);
  Future<Either<Failure, Unit>> clearChatHistory();
  Future<Either<Failure, ChatConversation?>> searchChatHistory(
      ChatConversation conversation);
}
