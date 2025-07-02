part of 'chat_history_bloc.dart';

abstract class ChatHistoryState extends Equatable {
  const ChatHistoryState();

  @override
  List<Object?> get props => [];
}

class ChatHistoryInitial extends ChatHistoryState {
  const ChatHistoryInitial();
}

class ChatHistoryLoading extends ChatHistoryState {
  const ChatHistoryLoading();
}

class ChatHistoryLoaded extends ChatHistoryState {
  final List<ChatConversation> conversations;

  const ChatHistoryLoaded({required this.conversations});

  @override
  List<Object?> get props => [conversations];
}

class ChatHistoryError extends ChatHistoryState {
  final String message;
  final List<ChatConversation> conversations; // Keep existing data if possible

  const ChatHistoryError({
    required this.message,
    this.conversations = const [],
  });

  @override
  List<Object?> get props => [message, conversations];
}
