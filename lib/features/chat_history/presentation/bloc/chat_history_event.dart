part of 'chat_history_bloc.dart';

abstract class ChatHistoryEvent extends Equatable {
  const ChatHistoryEvent();

  @override
  List<Object> get props => [];
}

class LoadChatHistory extends ChatHistoryEvent {
  const LoadChatHistory();
}

class SaveCurrentChatConversation extends ChatHistoryEvent {
  final List<ChatMessage> messages;

  const SaveCurrentChatConversation(this.messages);

  @override
  List<Object> get props => [messages];
}

class DeleteChatConversation extends ChatHistoryEvent {
  final String id;

  const DeleteChatConversation(this.id);

  @override
  List<Object> get props => [id];
}
