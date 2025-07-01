part of 'wakili_bloc.dart';

abstract class WakiliState extends Equatable {
  const WakiliState();

  @override
  List<Object?> get props => [];
}

class WakiliChatInitial extends WakiliState {
  const WakiliChatInitial();
}

class WakiliChatLoaded extends WakiliState {
  final List<ChatMessage> messages;
  final bool isLoading;
  final String? error;
  final String? selectedCategory;

  const WakiliChatLoaded({
    required this.messages,
    this.isLoading = false,
    this.error,
    this.selectedCategory,
  });

  WakiliChatLoaded copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
    String? error,
    String? selectedCategory,
  }) {
    return WakiliChatLoaded(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      selectedCategory: selectedCategory ?? this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [messages, isLoading, error, selectedCategory];
}

class WakiliChatErrorState extends WakiliState {
  final String message;
  final List<ChatMessage> messages;
  final String? selectedCategory;

  const WakiliChatErrorState({
    required this.message,
    required this.messages,
    this.selectedCategory,
  });

  @override
  List<Object?> get props => [message, messages, selectedCategory];
}
