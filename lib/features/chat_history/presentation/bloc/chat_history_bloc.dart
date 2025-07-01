import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/usecases/delete_chat_conversation_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/generate_chat_title_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/get_chat_history_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/save_chat_conversation_usecase.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

@injectable
class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final SaveChatConversationUseCase _saveChatConversationUseCase;
  final DeleteChatConversationUseCase _deleteChatConversationUseCase;
  final GenerateChatTitleUseCase _generateChatTitleUseCase;

  ChatHistoryBloc(
    this._getChatHistoryUseCase,
    this._saveChatConversationUseCase,
    this._deleteChatConversationUseCase,
    this._generateChatTitleUseCase,
  ) : super(ChatHistoryInitial()) {
    on<LoadChatHistory>(_onLoadChatHistory);
    on<SaveCurrentChatConversation>(_onSaveCurrentChatConversation);
    on<DeleteChatConversation>(_onDeleteChatConversation);
  }

  Future<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emit,
  ) async {
    emit(ChatHistoryLoading());
    try {
      final conversations = await _getChatHistoryUseCase();
      emit(ChatHistoryLoaded(conversations: conversations));
    } catch (e) {
      emit(ChatHistoryError(message: 'Failed to load chat history: $e'));
    }
  }

  Future<void> _onSaveCurrentChatConversation(
    SaveCurrentChatConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    if (event.messages.isEmpty) {
      return; // Don't save empty chats
    }

    // Generate title before saving
    final title = await _generateChatTitleUseCase(event.messages);

    final newConversation = ChatConversation(
      title: title,
      messages: event.messages,
      timestamp: DateTime.now(),
    );

    try {
      await _saveChatConversationUseCase(newConversation);
      // After saving, reload the history to reflect the new conversation
      final conversations = await _getChatHistoryUseCase();
      emit(ChatHistoryLoaded(conversations: conversations));
    } catch (e) {
      if (state is ChatHistoryLoaded) {
        emit(ChatHistoryError(
          message: 'Failed to save conversation: $e',
          conversations: (state as ChatHistoryLoaded).conversations,
        ));
      } else {
        emit(ChatHistoryError(message: 'Failed to save conversation: $e'));
      }
    }
  }

  Future<void> _onDeleteChatConversation(
    DeleteChatConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    // Optimistic update
    final currentState = state;
    if (currentState is ChatHistoryLoaded) {
      final updatedConversations = List<ChatConversation>.from(
          currentState.conversations.where((conv) => conv.id != event.id));
      emit(ChatHistoryLoaded(conversations: updatedConversations));
    }

    try {
      await _deleteChatConversationUseCase(event.id);
      // If the deletion fails, reload to revert the optimistic update
    } catch (e) {
      emit(ChatHistoryError(
        message: 'Failed to delete conversation: $e',
        conversations:
            currentState is ChatHistoryLoaded ? currentState.conversations : [],
      ));
      // Re-fetch to ensure state consistency if optimistic update failed
      add(LoadChatHistory());
    }
  }
}
