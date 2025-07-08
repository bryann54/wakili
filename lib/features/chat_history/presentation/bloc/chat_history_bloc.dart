import 'dart:async';

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

  FutureOr<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emit,
  ) async {
    emit(ChatHistoryLoading());
    final failureOrConversations = await _getChatHistoryUseCase();
    failureOrConversations.fold(
      (failure) => emit(ChatHistoryError(message: failure.toString())),
      (conversations) => emit(ChatHistoryLoaded(conversations: conversations)),
    );
  }

  FutureOr<void> _onSaveCurrentChatConversation(
    SaveCurrentChatConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    if (event.messages.isEmpty) {
      return; // Don't save empty chats
    }

    // Generate title before saving
    final failureOrTitle = await _generateChatTitleUseCase(event.messages);
    final title = failureOrTitle.fold(
      (failure) => 'Untitled Chat', // Fallback title on failure
      (generatedTitle) => generatedTitle,
    );

    final newConversation = ChatConversation(
      title: title,
      messages: event.messages,
      timestamp: DateTime.now(),
    );

    final failureOrUnit = await _saveChatConversationUseCase(newConversation);
    failureOrUnit.fold(
      (failure) {
        if (state is ChatHistoryLoaded) {
          emit(
            ChatHistoryError(
              message: 'Failed to save conversation: ${failure.toString()}',
              conversations: (state as ChatHistoryLoaded).conversations,
            ),
          );
        } else {
          emit(ChatHistoryError(
              message: 'Failed to save conversation: ${failure.toString()}'));
        }
      },
      (_) async {
        // After saving, reload the history to reflect the new conversation
        final updatedHistoryResult = await _getChatHistoryUseCase();
        updatedHistoryResult.fold(
          (failure) => emit(ChatHistoryError(
              message:
                  'Failed to refresh chat history after save: ${failure.toString()}')),
          (conversations) =>
              emit(ChatHistoryLoaded(conversations: conversations)),
        );
      },
    );
  }

  FutureOr<void> _onDeleteChatConversation(
    DeleteChatConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    // Optimistic update
    final currentState = state;
    if (currentState is ChatHistoryLoaded) {
      final updatedConversations = List<ChatConversation>.from(
        currentState.conversations.where((conv) => conv.id != event.id),
      );
      emit(ChatHistoryLoaded(conversations: updatedConversations));
    }

    final failureOrUnit = await _deleteChatConversationUseCase(event.id);
    failureOrUnit.fold(
      (failure) {
        // If the deletion fails, revert the optimistic update and emit an error
        emit(
          ChatHistoryError(
            message: 'Failed to delete conversation: ${failure.toString()}',
            conversations: currentState is ChatHistoryLoaded
                ? currentState.conversations // Revert to previous state
                : [],
          ),
        );
        // Re-fetch to ensure state consistency if optimistic update failed
        add(LoadChatHistory());
      },
      (_) {
        // Deletion successful, state is already updated optimistically
      },
    );
  }
}
