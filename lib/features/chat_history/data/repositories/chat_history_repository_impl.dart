import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/datasources/chat_history_datasource.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@LazySingleton(as: ChatHistoryRepository)
class ChatHistoryRepositoryImpl implements ChatHistoryRepository {
  final ChatHistoryLocalDataSource _localDataSource;

  ChatHistoryRepositoryImpl(this._localDataSource);

  @override
  Future<List<ChatConversation>> getChatHistory() {
    return _localDataSource.getChatHistory();
  }

  @override
  Future<void> saveChatConversation(ChatConversation conversation) {
    return _localDataSource.saveChatConversation(conversation);
  }

  @override
  Future<void> deleteChatConversation(String conversationId) {
    return _localDataSource.deleteChatConversation(conversationId);
  }

  @override
  Future<void> updateChatConversation(ChatConversation conversation) {
    return _localDataSource.updateChatConversation(conversation);
  }
}
