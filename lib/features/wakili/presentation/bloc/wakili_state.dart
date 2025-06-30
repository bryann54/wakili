part of 'wakili_bloc.dart';

abstract class WakiliState extends Equatable {
  const WakiliState();
}

class WakiliChatInitial extends WakiliState {
  @override
  List<Object> get props => [];
}

class WakiliChatLoaded extends WakiliState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;

  const WakiliChatLoaded({
    required this.messages,
    this.isLoading = false,
    this.error,
  });

  WakiliChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
  }) {
    return WakiliChatLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error];
}