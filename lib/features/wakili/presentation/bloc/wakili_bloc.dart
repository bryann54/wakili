import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_usecase.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_stream_usecase.dart';

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessageUseCase;
  final SendMessageStreamUseCase _sendMessageStreamUseCase;

  WakiliBloc(
    this._sendMessageUseCase,
    this._sendMessageStreamUseCase,
  ) : super(WakiliChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendStreamMessageEvent>(_onSendStreamMessage);
    on<ClearChatEvent>(_onClearChat);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    List<ChatMessage> currentMessages = [];
    if (state is WakiliChatLoaded) {
      currentMessages = (state as WakiliChatLoaded).messages;
    } else if (state is WakiliChatErrorState) {
      currentMessages = (state as WakiliChatErrorState).messages;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message and set loading
    emit(WakiliChatLoaded(
      messages: [...currentMessages, userMessage],
      isLoading: true,
      error: null,
    ));

    try {
      final response = await _sendMessageUseCase(event.message);
      final aiMessage = ChatMessage(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        content: response,
        isUser: false,
        timestamp: DateTime.now(),
      );

      final newState = state as WakiliChatLoaded;
      emit(newState.copyWith(
        messages: [...newState.messages, aiMessage],
        isLoading: false,
      ));
    } catch (e) {
      final List<ChatMessage> newStateMessages =
          state is WakiliChatLoaded ? (state as WakiliChatLoaded).messages : <ChatMessage>[];
      emit(WakiliChatErrorState(
          message: "Failed to get response: ${e.toString()}",
          messages: newStateMessages));
    }
  }

  Future<void> _onSendStreamMessage(
    SendStreamMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    List<ChatMessage> currentMessages = [];
    if (state is WakiliChatLoaded) {
      currentMessages = (state as WakiliChatLoaded).messages;
    } else if (state is WakiliChatErrorState) {
      // Carry over messages from error state
      currentMessages = (state as WakiliChatErrorState).messages;
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message and set loading to true
    emit(WakiliChatLoaded(
      messages: [...currentMessages, userMessage],
      isLoading: true,
      error: null,
    ));

    try {
      String accumulatedResponse = '';
      final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();

      await for (final chunk in _sendMessageStreamUseCase(event.message)) {
        accumulatedResponse += chunk;

        final aiMessage = ChatMessage(
          id: aiMessageId,
          content: accumulatedResponse,
          isUser: false,
          timestamp:
              DateTime.now(), // Timestamp can be updated or fixed to start
        );

        final currentStateForStream = state is WakiliChatLoaded
            ? (state as WakiliChatLoaded)
            : WakiliChatLoaded(messages: currentMessages, isLoading: true);
        final updatedMessages =
            List<ChatMessage>.from(currentStateForStream.messages);

        // Find and replace the placeholder AI message or add if it's the first chunk
        final existingIndex = updatedMessages.indexWhere(
          (msg) => msg.id == aiMessageId && !msg.isUser,
        );

        if (existingIndex != -1) {
          updatedMessages[existingIndex] = aiMessage;
        } else {
          updatedMessages.add(aiMessage);
        }

        // Emit new state with partial response, still loading until stream completes
        emit(currentStateForStream.copyWith(
          messages: updatedMessages,
          isLoading: true, // Still loading until stream finishes
        ));
      }
      // After stream completes, set isLoading to false.
      // Need to cast state to WakiliChatLoaded explicitly as it might be WakiliChatLoadingState
      final finalStateAfterStream = state is WakiliChatLoaded
          ? state as WakiliChatLoaded
          : WakiliChatLoaded(messages: currentMessages, isLoading: false);
      emit(finalStateAfterStream.copyWith(isLoading: false));
    } catch (e) {
      final newStateMessages = state is WakiliChatLoaded
          ? (state as WakiliChatLoaded).messages
          : currentMessages;
      emit(WakiliChatErrorState(
          message: "Failed to get streaming response: ${e.toString()}",
          messages: newStateMessages));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<WakiliState> emit) {
    emit(const WakiliChatLoaded(
        messages: [])); // Changed to loaded with empty list
  }
}
