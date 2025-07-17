part of 'chat_history_bloc.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object?> get props => [];
}

class SaveCurrentConversation extends ChatHistoryEvent {
  final String userId;
  final String category;
  final List<ChatMessage> messages;
  final String? conversationId; // Null for new conversations

  const SaveCurrentConversation({
    required this.userId,
    required this.category,
    required this.messages,
    this.conversationId,
  });

  @override
  List<Object?> get props => [userId, category, messages, conversationId];
}

class LoadChatHistory extends ChatHistoryEvent {
  final String userId;

  const LoadChatHistory({required this.userId});

  @override
  List<Object?> get props => [userId];
}

class LoadSingleConversation extends ChatHistoryEvent {
  final String conversationId;
  final String userId;

  const LoadSingleConversation(
      {required this.conversationId, required this.userId});

  @override
  List<Object> get props => [conversationId, userId];
}

class DeleteConversation extends ChatHistoryEvent {
  final String conversationId;
  final String userId;

  const DeleteConversation({
    required this.conversationId,
    required this.userId,
  });

  @override
  List<Object> get props => [conversationId, userId];
}
