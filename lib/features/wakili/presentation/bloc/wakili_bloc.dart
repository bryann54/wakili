import 'dart:async';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/domain/usecases/get_legal_categories_usecase.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_usecase.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_stream_usecase.dart';
import 'package:uuid/uuid.dart';
import 'package:firebase_auth/firebase_auth.dart'; // ✨ IMPORT FIREBASE AUTH ✨

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessage;
  final SendMessageStreamUseCase _sendStreamMessage;
  final ChatHistoryBloc _chatHistoryBloc;
  final GetLegalCategoriesUseCase _getLegalCategories;

  String? _currentConversationId;
  // Removed hardcoded _currentUserId. It will be fetched dynamically.

  WakiliBloc(
    this._sendMessage,
    this._sendStreamMessage,
    this._chatHistoryBloc,
    this._getLegalCategories,
  ) : super(WakiliChatInitial()) {
    on<SendMessageEvent>(_onSendMessage);
    on<SendStreamMessageEvent>(_onSendStreamMessage);
    on<ClearChatEvent>(_onClearChat);
    on<SetCategoryContextEvent>(_onSetCategoryContext);
    on<ClearCategoryContextEvent>(_onClearCategoryContext);
    on<LoadExistingChat>(_onLoadExistingChat);
    on<LoadExistingChatWithCategory>(_onLoadExistingChatWithCategory);
    on<LoadLegalCategories>(_onLoadLegalCategories);

    _chatHistoryBloc.stream.listen((chatHistoryState) {
      if (chatHistoryState is ChatHistoryLoaded) {
        _currentConversationId = chatHistoryState.currentConversationId;
      }
    });

    // ✨ LOAD CHAT HISTORY WITH AUTHENTICATED USER ID ON BLOC INITIALIZATION ✨
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _chatHistoryBloc.add(LoadChatHistory(userId: user.uid));
      } else {
        // Handle unauthenticated state if necessary, e.g., clear chat history
        _chatHistoryBloc.add(const ChatHistoryLoaded(conversations: [])
            as ChatHistoryEvent); // Or a different state
      }
    });

    add(const LoadLegalCategories()); // Still load categories
  }

  FutureOr<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    final current = _extractChatData(state);
    final contextMessage =
        _applyCategoryContext(event.message, current.category);

    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    emit(WakiliChatLoaded(
      messages: [...current.messages, userMessage],
      isLoading: true,
      selectedCategory: current.category,
    ));

    final result = await _sendMessage(
      contextMessage,
      conversationHistory: current.messages,
    );
    result.fold(
      (failure) => emit(WakiliChatErrorState(
        message: _mapFailureToMessage(failure),
        messages: [...current.messages, userMessage],
        selectedCategory: current.category,
      )),
      (response) {
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
        emit(WakiliChatLoaded(
          messages: [...current.messages, userMessage, aiMessage],
          isLoading: false,
          selectedCategory: current.category,
        ));
      },
    );
  }

  Future<void> _onSendStreamMessage(
    SendStreamMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    final currentState = state;
    if (currentState is! WakiliChatLoaded) {
      emit(const WakiliChatLoaded(messages: [], isLoading: true));
    }

    final WakiliChatLoaded loadedState = (state is WakiliChatLoaded)
        ? state as WakiliChatLoaded
        : const WakiliChatLoaded(messages: []);

    final userMessage = ChatMessage(
      id: const Uuid().v4(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final updatedMessages = List<ChatMessage>.from(loadedState.messages)
      ..add(userMessage);

    emit(loadedState.copyWith(
      messages: updatedMessages,
      isLoading: true,
      error: null,
    ));

    // ✨ GET AUTHENTICATED USER UID HERE ✨
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      // Handle the case where the user is somehow unauthenticated
      emit(WakiliChatErrorState(
        message: 'You must be logged in to save conversations.',
        messages: updatedMessages,
        selectedCategory: loadedState.selectedCategory,
        allCategories: loadedState.allCategories,
      ));
      return; // Stop further execution if no user
    }

    // Attempt to save the user message immediately
    _chatHistoryBloc.add(SaveCurrentConversation(
      userId: currentUserUid, // ✨ PASS THE ACTUAL UID HERE ✨
      category: loadedState.selectedCategory ?? 'General',
      messages: updatedMessages,
      conversationId: _currentConversationId,
    ));

    String fullBotResponse = '';
    await emit.forEach<Either<Failure, String>>(
      _sendStreamMessage(
        event.message,
        conversationHistory: updatedMessages,
      ),
      onData: (either) {
        return either.fold(
          (failure) {
            return WakiliChatErrorState(
              message: _mapFailureToMessage(failure),
              messages: updatedMessages,
              selectedCategory: loadedState.selectedCategory,
              allCategories: loadedState.allCategories,
            );
          },
          (chunk) {
            fullBotResponse += chunk;
            final List<ChatMessage> currentMessages =
                List.from(updatedMessages);
            int botMessageIndex = -1;
            for (int i = currentMessages.length - 1; i >= 0; i--) {
              if (!currentMessages[i].isUser) {
                botMessageIndex = i;
                break;
              }
            }

            if (botMessageIndex != -1) {
              currentMessages[botMessageIndex] =
                  currentMessages[botMessageIndex].copyWith(
                content: fullBotResponse,
              );
            } else {
              currentMessages.add(ChatMessage(
                id: const Uuid().v4(),
                content: fullBotResponse,
                isUser: false,
                timestamp: DateTime.now(),
              ));
            }

            return loadedState.copyWith(
              messages: currentMessages,
              isLoading: true,
              error: null,
            );
          },
        );
      },
      onError: (error, stackTrace) {
        final Failure failure = _mapErrorToFailure(error);
        return WakiliChatErrorState(
          message: _mapFailureToMessage(failure),
          messages: updatedMessages,
          selectedCategory: loadedState.selectedCategory,
          allCategories: loadedState.allCategories,
        );
      },
    ).then((_) {
      final finalMessages = List<ChatMessage>.from(updatedMessages);
      if (fullBotResponse.isNotEmpty) {
        int botMessageIndex = -1;
        for (int i = finalMessages.length - 1; i >= 0; i--) {
          if (!finalMessages[i].isUser) {
            botMessageIndex = i;
            break;
          }
        }
        if (botMessageIndex != -1) {
          finalMessages[botMessageIndex] =
              finalMessages[botMessageIndex].copyWith(
            content: fullBotResponse,
          );
        } else {
          finalMessages.add(ChatMessage(
            id: const Uuid().v4(),
            content: fullBotResponse,
            isUser: false,
            timestamp: DateTime.now(),
          ));
        }
      }
      // ✨ GET AUTHENTICATED USER UID HERE AGAIN FOR FINAL SAVE ✨
      final currentUserUidAfterStream = FirebaseAuth.instance.currentUser?.uid;
      if (currentUserUidAfterStream != null) {
        _chatHistoryBloc.add(SaveCurrentConversation(
          userId: currentUserUidAfterStream, // ✨ PASS THE ACTUAL UID HERE ✨
          category: loadedState.selectedCategory ?? 'General',
          messages: finalMessages,
          conversationId: _currentConversationId,
        ));
      } else {
        print(
            'Error: User unauthenticated after stream completed, conversation not saved.');
        // Consider a more robust error handling or state
      }
      emit(loadedState.copyWith(isLoading: false));
    });
  }

  Future<void> _onClearChat(
      ClearChatEvent event, Emitter<WakiliState> emit) async {
    emit(WakiliChatLoaded(
      messages: const [],
      selectedCategory: (state is WakiliChatLoaded)
          ? (state as WakiliChatLoaded).selectedCategory
          : null,
      allCategories: (state is WakiliChatLoaded)
          ? (state as WakiliChatLoaded).allCategories
          : const [],
    ));
    _currentConversationId = null;
  }

  void _onSetCategoryContext(
    SetCategoryContextEvent event,
    Emitter<WakiliState> emit,
  ) {
    final current = _extractChatData(state);
    emit(WakiliChatLoaded(
      messages: current.messages,
      selectedCategory: event.category,
    ));
  }

  void _onClearCategoryContext(
    ClearCategoryContextEvent event,
    Emitter<WakiliState> emit,
  ) {
    final current = _extractChatData(state);
    emit(WakiliChatLoaded(
      messages: current.messages,
      selectedCategory: null,
    ));
  }

  void _onLoadExistingChat(
    LoadExistingChat event,
    Emitter<WakiliState> emit,
  ) {
    emit(WakiliChatLoaded(
      messages: event.messages,
    ));
  }

  FutureOr<void> _onLoadLegalCategories(
    LoadLegalCategories event,
    Emitter<WakiliState> emit,
  ) async {
    final current = _extractChatData(state);
    emit(WakiliChatLoaded(
      messages: current.messages,
      isLoading: true,
      selectedCategory: current.category,
      allCategories: current.allCategories,
    ));

    final result = await _getLegalCategories();
    result.fold(
      (failure) => emit(WakiliChatErrorState(
        message: _mapFailureToMessage(failure),
        messages: current.messages,
        selectedCategory: current.category,
        allCategories: current.allCategories,
      )),
      (categories) {
        emit(WakiliChatLoaded(
          messages: current.messages,
          isLoading: false,
          selectedCategory: current.category,
          allCategories: categories,
        ));
      },
    );
  }

  Future<void> _onLoadExistingChatWithCategory(
    LoadExistingChatWithCategory event,
    Emitter<WakiliState> emit,
  ) async {
    _currentConversationId = event.conversationId;
    emit(WakiliChatLoaded(
      messages: event.messages,
      selectedCategory: event.category,
      isLoading: false,
    ));
  }

  ({
    List<ChatMessage> messages,
    String? category,
    List<LegalCategory> allCategories
  }) _extractChatData(WakiliState state) {
    if (state is WakiliChatLoaded) {
      return (
        messages: state.messages,
        category: state.selectedCategory,
        allCategories: state.allCategories
      );
    } else if (state is WakiliChatErrorState) {
      return (
        messages: state.messages,
        category: state.selectedCategory,
        allCategories: state.allCategories
      );
    } else {
      return (messages: [], category: null, allCategories: []);
    }
  }

  String _applyCategoryContext(String message, String? category) {
    return category != null
        ? 'In the context of $category law: $message'
        : message;
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) {
      return failure.message;
    } else if (failure is CacheFailure) {
      return failure.message;
    } else if (failure is ConnectionFailure) {
      return failure.message;
    } else if (failure is ClientFailure) {
      return failure.message;
    } else if (failure is ValidationFailure) {
      return failure.message;
    } else if (failure is GeneralFailure) {
      return failure.message;
    }
    return 'An unexpected error occurred.';
  }

  Failure _mapErrorToFailure(Object error) {
    if (error is Exception) {
      return GeneralFailure(message: 'Application Error: ${error.toString()}');
    }
    return const GeneralFailure(message: 'An unknown critical error occurred.');
  }
}
