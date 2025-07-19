// chat_history_bloc.dart
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/usecases/delete_conversation_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/generate_chat_title_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/get_conversation_by_id_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/get_conversations_usecase.dart';
import 'package:wakili/features/chat_history/domain/usecases/save_conversation_usecase.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:uuid/uuid.dart';

part 'chat_history_event.dart';
part 'chat_history_state.dart';

@injectable
class ChatHistoryBloc extends Bloc<ChatHistoryEvent, ChatHistoryState> {
  final SaveConversationUseCase _saveConversationUseCase;
  final GetConversationsUseCase _getConversationsUseCase;
  final GetConversationByIdUseCase _getConversationByIdUseCase;
  final DeleteConversationUseCase _deleteConversationUseCase;
  final GenerateChatTitleUseCase _generateChatTitleUseCase;

  ChatHistoryBloc(
    this._saveConversationUseCase,
    this._getConversationsUseCase,
    this._getConversationByIdUseCase,
    this._deleteConversationUseCase,
    this._generateChatTitleUseCase,
  ) : super(const ChatHistoryInitial()) {
    on<SaveCurrentConversation>(_onSaveCurrentConversation);
    on<LoadChatHistory>(_onLoadChatHistory);
    on<LoadSingleConversation>(_onLoadSingleConversation);
    on<DeleteConversation>(_onDeleteConversation);
    on<ClearChatHistoryEvent>(_onClearChatHistory);
  }

  FutureOr<void> _onSaveCurrentConversation(
    SaveCurrentConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    if (event.messages.isEmpty) {
      emit(ChatHistoryLoaded(
        conversations: state.conversations,
        currentConversationId: state.currentConversationId,
        activeConversationMessages: state.activeConversationMessages,
        message: 'No messages to save.',
      ));
      return;
    }

    final currentConversations = state.conversations;
    emit(ChatHistoryLoading(
      conversations: currentConversations,
      currentConversationId: state.currentConversationId,
      activeConversationMessages: event.messages,
    ));

    final String conversationIdToSave =
        event.conversationId ?? const Uuid().v4();

    final String generatedTitle =
        await _generateChatTitleUseCase(event.messages);

    final result = await _saveConversationUseCase(SaveConversationParams(
      userId: event.userId,
      category: event.category,
      messages: event.messages,
      conversationId: conversationIdToSave,
      title: generatedTitle,
    ));

    result.fold(
      (failure) => emit(ChatHistoryError(
        message: (failure as dynamic).message ?? 'An unknown error occurred',
        conversations: currentConversations,
        currentConversationId: state.currentConversationId,
        activeConversationMessages: state.activeConversationMessages,
      )),
      (_) {
        add(LoadChatHistory(userId: event.userId));
        emit(ChatHistoryLoaded(
          conversations: currentConversations,
          currentConversationId: conversationIdToSave,
          activeConversationMessages: event.messages,
          message: 'Chat saved successfully!',
        ));
      },
    );
  }

  FutureOr<void> _onClearChatHistory(
    ClearChatHistoryEvent event,
    Emitter<ChatHistoryState> emit,
  ) {
    emit(const ChatHistoryInitial());
  }

  FutureOr<void> _onLoadChatHistory(
    LoadChatHistory event,
    Emitter<ChatHistoryState> emit,
  ) async {
    emit(const ChatHistoryLoading());

    final result = await _getConversationsUseCase(event.userId);

    result.fold(
      (failure) => emit(ChatHistoryError(
        message: (failure as dynamic).message ?? 'An unknown error occurred',
        conversations: state.conversations,
        currentConversationId: state.currentConversationId,
        activeConversationMessages: state.activeConversationMessages,
      )),
      (rawConversations) {
        final List<ChatConversation> conversations = rawConversations
            .map((map) => ChatConversation.fromJson(map))
            .toList();

        String? newCurrentConversationId = state.currentConversationId;
        List<ChatMessage> newActiveConversationMessages =
            state.activeConversationMessages;

        if (newCurrentConversationId != null) {
          final updatedActiveConversation = conversations
              .firstWhereOrNull((conv) => conv.id == newCurrentConversationId);
          if (updatedActiveConversation != null) {
            newActiveConversationMessages = updatedActiveConversation.messages;
          } else {
            newCurrentConversationId = null;
            newActiveConversationMessages = const [];
          }
        }

        emit(ChatHistoryLoaded(
          conversations: conversations,
          currentConversationId: newCurrentConversationId,
          activeConversationMessages: newActiveConversationMessages,
          message: state is ChatHistoryLoading && state.message != null
              ? state.message
              : null,
        ));
      },
    );
  }

  FutureOr<void> _onLoadSingleConversation(
    LoadSingleConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    final List<ChatConversation> previousConversations = state.conversations;

    emit(ChatHistoryLoading(
      conversations: previousConversations,
      currentConversationId: state.currentConversationId,
      activeConversationMessages: state.activeConversationMessages,
    ));

    final result = await _getConversationByIdUseCase(event.conversationId);

    result.fold(
      (failure) => emit(ChatHistoryError(
        message: (failure as dynamic).message ?? 'An unknown error occurred',
        conversations: previousConversations,
        currentConversationId: state.currentConversationId,
        activeConversationMessages: state.activeConversationMessages,
      )),
      (conversationData) {
        if (conversationData != null) {
          final ChatConversation loadedConversation =
              ChatConversation.fromJson(conversationData);

          final updatedConversations =
              List<ChatConversation>.from(previousConversations);
          final index = updatedConversations
              .indexWhere((conv) => conv.id == loadedConversation.id);
          if (index != -1) {
            updatedConversations[index] = loadedConversation;
          } else {
            updatedConversations.add(loadedConversation);
          }

          emit(ChatHistoryLoaded(
            conversations: updatedConversations,
            currentConversationId: loadedConversation.id,
            activeConversationMessages: loadedConversation.messages,
          ));
        } else {
          emit(ChatHistoryError(
            message: 'Conversation not found.',
            conversations: previousConversations,
            currentConversationId: state.currentConversationId,
            activeConversationMessages: state.activeConversationMessages,
          ));
        }
      },
    );
  }

  FutureOr<void> _onDeleteConversation(
    DeleteConversation event,
    Emitter<ChatHistoryState> emit,
  ) async {
    final List<ChatConversation> conversationsBeforeDelete =
        state.conversations;
    final String? currentConversationIdBeforeDelete =
        state.currentConversationId;
    final List<ChatMessage> activeConversationMessagesBeforeDelete =
        state.activeConversationMessages;

    emit(ChatHistoryLoading(
      conversations: conversationsBeforeDelete,
      currentConversationId: currentConversationIdBeforeDelete,
      activeConversationMessages: activeConversationMessagesBeforeDelete,
    ));

    final result = await _deleteConversationUseCase(event.conversationId);

    result.fold(
      (failure) {
        emit(ChatHistoryError(
          message: (failure as dynamic).message ??
              'An unknown error occurred during deletion.',
          conversations: conversationsBeforeDelete,
          currentConversationId: currentConversationIdBeforeDelete,
          activeConversationMessages: activeConversationMessagesBeforeDelete,
        ));
      },
      (_) {
        final updatedConversations = conversationsBeforeDelete
            .where((conv) => conv.id != event.conversationId)
            .toList();

        String? newCurrentConversationId = currentConversationIdBeforeDelete;
        List<ChatMessage> newActiveConversationMessages =
            activeConversationMessagesBeforeDelete;
        if (newCurrentConversationId == event.conversationId) {
          newCurrentConversationId = null;
          newActiveConversationMessages = const [];
        }

        emit(ChatHistoryLoaded(
          conversations: updatedConversations,
          currentConversationId: newCurrentConversationId,
          activeConversationMessages: newActiveConversationMessages,
          message: 'Conversation deleted successfully!',
        ));
      },
    );
  }
}

extension ListExtensions<T> on List<T> {
  T? firstWhereOrNull(bool Function(T element) test) {
    for (var element in this) {
      if (test(element)) {
        return element;
      }
    }
    return null;
  }
}
