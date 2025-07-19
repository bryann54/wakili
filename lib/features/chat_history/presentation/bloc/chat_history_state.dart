// chat_history_state.dart
part of 'chat_history_bloc.dart';

abstract class ChatHistoryState extends Equatable {
  final List<ChatConversation> conversations;
  final String? currentConversationId;
  final List<ChatMessage> activeConversationMessages;
  final String? message;

  const ChatHistoryState({
    this.conversations = const [],
    this.currentConversationId,
    this.activeConversationMessages = const [],
    this.message,
  });

  @override
  List<Object?> get props => [
        conversations,
        currentConversationId,
        activeConversationMessages,
        message,
      ];
}

class ChatHistoryInitial extends ChatHistoryState {
  const ChatHistoryInitial();
}

class ChatHistoryLoading extends ChatHistoryState {
  const ChatHistoryLoading({
    super.conversations,
    super.currentConversationId,
    super.activeConversationMessages,
    super.message,
  });
}

class ChatHistoryLoaded extends ChatHistoryState {
  const ChatHistoryLoaded({
    super.conversations,
    super.currentConversationId,
    super.activeConversationMessages,
    super.message,
  });
}

class ChatHistoryError extends ChatHistoryState {
  const ChatHistoryError({
    required String message,
    super.conversations,
    super.currentConversationId,
    super.activeConversationMessages,
  }) : super(message: message);
}
