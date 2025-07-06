import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';

abstract class ChatHistoryLocalDataSource {
  Future<List<ChatConversation>> getChatHistory();
  Future<void> saveChatConversation(ChatConversation conversation);
  Future<void> deleteChatConversation(String conversationId);
  Future<void> updateChatConversation(ChatConversation conversation);
  Future<void> clearChatHistory();
  Future<ChatConversation?> searchChatHistory(ChatConversation conversation);
}

@LazySingleton(as: ChatHistoryLocalDataSource)
class ChatHistoryLocalDataSourceImpl implements ChatHistoryLocalDataSource {
  static const String _boxName = 'chatConversations';

  Future<Box<ChatConversation>> _openBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<ChatConversation>(_boxName);
    }
    return Hive.box<ChatConversation>(_boxName);
  }

  @override
  Future<List<ChatConversation>> getChatHistory() async {
    final box = await _openBox();
    return box.values.toList().cast<ChatConversation>();
  }

  @override
  Future<void> saveChatConversation(ChatConversation conversation) async {
    final box = await _openBox();
    await box.put(conversation.id, conversation);
  }

  @override
  Future<void> deleteChatConversation(String conversationId) async {
    final box = await _openBox();
    await box.delete(conversationId);
  }

  @override
  Future<void> updateChatConversation(ChatConversation conversation) async {
    final box = await _openBox();
    await box.put(conversation.id, conversation);
  }

  @override
  Future<void> clearChatHistory() async {
    final box = await _openBox();
    await box.clear();
  }

  @override
  Future<ChatConversation?> searchChatHistory(
      ChatConversation conversation) async {
    final box = await _openBox();
    try {
      try {
        return box.values.firstWhere(
          (c) => c.id == conversation.id,
        );
      } catch (_) {
        return null;
      }
    } catch (_) {
      return null;
    }
  }
}
