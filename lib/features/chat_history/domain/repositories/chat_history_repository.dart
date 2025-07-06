import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

abstract class ChatHistoryRepository {
  Future<List<ChatConversation>> getChatHistory();
  Future<void> saveChatConversation(ChatConversation conversation);
  Future<void> deleteChatConversation(String conversationId);
  Future<void> updateChatConversation(ChatConversation conversation);
  Future<void> clearChatHistory();
  Future<ChatConversation?> searchChatHistory(ChatConversation conversation);
}
