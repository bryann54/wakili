import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_usecase.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_stream_usecase.dart';

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessageUseCase;
  final SendMessageStreamUseCase _sendMessageStreamUseCase;
  final ChatHistoryBloc _chatHistoryBloc;

  WakiliBloc(
    this._sendMessageUseCase,
    this._sendMessageStreamUseCase,
    this._chatHistoryBloc,
  ) : super(WakiliChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendStreamMessageEvent>(_onSendStreamMessage);
    on<ClearChatEvent>(_onClearChat);
    on<SetCategoryContextEvent>(_onSetCategoryContext);
    on<ClearCategoryContextEvent>(_onClearCategoryContext);
     on<LoadExistingChat>(_onLoadExistingChat);
    on<LoadExistingChatWithCategory>(_onLoadExistingChatWithCategory);
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    List<ChatMessage> currentMessages = [];
    String? selectedCategory;

    if (state is WakiliChatLoaded) {
      currentMessages = (state as WakiliChatLoaded).messages;
      selectedCategory = (state as WakiliChatLoaded).selectedCategory;
    } else if (state is WakiliChatErrorState) {
      currentMessages = (state as WakiliChatErrorState).messages;
      selectedCategory = (state as WakiliChatErrorState).selectedCategory;
    }

    // Add category context to the message if a category is selected
    String messageWithContext = event.message;
    if (selectedCategory != null) {
      messageWithContext =
          "In the context of $selectedCategory law: ${event.message}";
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message, // Show original message to user
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message and set loading
    emit(WakiliChatLoaded(
      messages: [...currentMessages, userMessage],
      isLoading: true,
      error: null,
      selectedCategory: selectedCategory,
    ));

    try {
      final response = await _sendMessageUseCase(
          messageWithContext); // Use context message for AI
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
      final List<ChatMessage> newStateMessages = state is WakiliChatLoaded
          ? (state as WakiliChatLoaded).messages
          : <ChatMessage>[];
      emit(WakiliChatErrorState(
          message: "Failed to get response: ${e.toString()}",
          messages: newStateMessages,
          selectedCategory: selectedCategory));
    }
  }

  Future<void> _onSendStreamMessage(
    SendStreamMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    List<ChatMessage> currentMessages = [];
    String? selectedCategory;

    if (state is WakiliChatLoaded) {
      currentMessages = (state as WakiliChatLoaded).messages;
      selectedCategory = (state as WakiliChatLoaded).selectedCategory;
    } else if (state is WakiliChatErrorState) {
      currentMessages = (state as WakiliChatErrorState).messages;
      selectedCategory = (state as WakiliChatErrorState).selectedCategory;
    }

    // Add category context to the message if a category is selected
    String messageWithContext = event.message;
    if (selectedCategory != null) {
      messageWithContext =
          "In the context of $selectedCategory law: ${event.message}";
    }

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message, // Show original message to user
      isUser: true,
      timestamp: DateTime.now(),
    );

    // Add user message and set loading to true
    emit(WakiliChatLoaded(
      messages: [...currentMessages, userMessage],
      isLoading: true,
      error: null,
      selectedCategory: selectedCategory,
    ));

    try {
      String accumulatedResponse = '';
      final aiMessageId = DateTime.now().millisecondsSinceEpoch.toString();

      await for (final chunk in _sendMessageStreamUseCase(messageWithContext)) {
        // Use context message for AI
        accumulatedResponse += chunk;

        final aiMessage = ChatMessage(
          id: aiMessageId,
          content: accumulatedResponse,
          isUser: false,
          timestamp: DateTime.now(),
        );

        final currentStateForStream = state is WakiliChatLoaded
            ? (state as WakiliChatLoaded)
            : WakiliChatLoaded(
                messages: currentMessages,
                isLoading: true,
                selectedCategory: selectedCategory,
              );
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
      final finalStateAfterStream = state is WakiliChatLoaded
          ? state as WakiliChatLoaded
          : WakiliChatLoaded(
              messages: currentMessages,
              isLoading: false,
              selectedCategory: selectedCategory,
            );
      emit(finalStateAfterStream.copyWith(isLoading: false));
    } catch (e) {
      final newStateMessages = state is WakiliChatLoaded
          ? (state as WakiliChatLoaded).messages
          : currentMessages;
      emit(WakiliChatErrorState(
          message: "Failed to get streaming response: ${e.toString()}",
          messages: newStateMessages,
          selectedCategory: selectedCategory));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<WakiliState> emit) {
    // Save the current chat messages to history before clearing
    List<ChatMessage> messagesToSave = [];
    if (state is WakiliChatLoaded) {
      messagesToSave = (state as WakiliChatLoaded).messages;
    } else if (state is WakiliChatErrorState) {
      messagesToSave = (state as WakiliChatErrorState).messages;
    }

    if (messagesToSave.isNotEmpty) {
      // Dispatch an event to the ChatHistoryBloc to save the conversation
      _chatHistoryBloc.add(SaveCurrentChatConversation(messagesToSave));
    }

    // Preserve selected category when clearing chat
    String? selectedCategory;
    if (state is WakiliChatLoaded) {
      selectedCategory = (state as WakiliChatLoaded).selectedCategory;
    } else if (state is WakiliChatErrorState) {
      selectedCategory = (state as WakiliChatErrorState).selectedCategory;
    }
    emit(WakiliChatLoaded(
      messages: [],
      selectedCategory: selectedCategory,
    ));
  }

  void _onSetCategoryContext(
    SetCategoryContextEvent event,
    Emitter<WakiliState> emit,
  ) {
    if (state is WakiliChatLoaded) {
      final currentState = state as WakiliChatLoaded;
      emit(currentState.copyWith(selectedCategory: event.category));
    } else if (state is WakiliChatErrorState) {
      final currentState = state as WakiliChatErrorState;
      emit(WakiliChatLoaded(
        messages: currentState.messages,
        selectedCategory: event.category,
      ));
    } else {
      // If in initial state, transition to loaded with empty messages but selected category
      emit(WakiliChatLoaded(
        messages: const [],
        selectedCategory: event.category,
      ));
    }
  }

  void _onClearCategoryContext(
    ClearCategoryContextEvent event,
    Emitter<WakiliState> emit,
  ) {
    if (state is WakiliChatLoaded) {
      final currentState = state as WakiliChatLoaded;
      emit(currentState.copyWith(selectedCategory: null));
    } else if (state is WakiliChatErrorState) {
      final currentState = state as WakiliChatErrorState;
      emit(WakiliChatLoaded(
        messages: currentState.messages,
        selectedCategory: null,
      ));
    }
  }

  void _onLoadExistingChat(LoadExistingChat event, Emitter<WakiliState> emit) {
    emit(WakiliChatLoaded(
      messages: event.messages,
      isLoading: false,
      error: null,
      selectedCategory: null,
    ));
  }

  void _onLoadExistingChatWithCategory(
      LoadExistingChatWithCategory event, Emitter<WakiliState> emit) {
    emit(WakiliChatLoaded(
      messages: event.messages,
      isLoading: false,
      error: null,
      selectedCategory: event.category,
    ));
  }

}
