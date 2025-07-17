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
import 'package:firebase_auth/firebase_auth.dart';

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessage;
  final SendMessageStreamUseCase _sendStreamMessage;
  final ChatHistoryBloc _chatHistoryBloc;
  final GetLegalCategoriesUseCase _getLegalCategories;

  String? _currentConversationId;
  final Uuid _uuid = const Uuid();

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
    on<SaveCurrentChatEvent>(_onSaveCurrentChatEvent);

    _chatHistoryBloc.stream.listen((chatHistoryState) {
      if (chatHistoryState is ChatHistoryLoaded) {
        if (chatHistoryState.currentConversationId != null &&
            state is WakiliChatLoaded &&
            (state as WakiliChatLoaded).messages.isNotEmpty &&
            _currentConversationId == null) {
          _currentConversationId = chatHistoryState.currentConversationId;
        }
      }
    });

    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user != null) {
        _chatHistoryBloc.add(LoadChatHistory(userId: user.uid));
      } else {
        _chatHistoryBloc.add(const ClearChatHistoryEvent());
      }
    });

    add(const LoadLegalCategories());
  }

  FutureOr<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    final current = _extractChatData(state);
    final contextMessage =
        _applyCategoryContext(event.message, current.category);

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final messagesWithUserMessage = [...current.messages, userMessage];

    emit(WakiliChatLoaded(
      messages: messagesWithUserMessage,
      isLoading: true,
      selectedCategory: current.category,
      allCategories: current.allCategories,
    ));

    final result = await _sendMessage(
      contextMessage,
      conversationHistory: messagesWithUserMessage,
    );

    result.fold(
      (failure) => emit(WakiliChatErrorState(
        message: _mapFailureToMessage(failure),
        messages: messagesWithUserMessage,
        selectedCategory: current.category,
        allCategories: current.allCategories,
      )),
      (response) {
        final aiMessage = ChatMessage(
          id: _uuid.v4(),
          content: response,
          isUser: false,
          timestamp: DateTime.now(),
        );
        final updatedMessages = [...messagesWithUserMessage, aiMessage];
        emit(WakiliChatLoaded(
          messages: updatedMessages,
          isLoading: false,
          selectedCategory: current.category,
          allCategories: current.allCategories,
        ));
      },
    );
    add(const SaveCurrentChatEvent());
  }

  FutureOr<void> _onSendStreamMessage(
    SendStreamMessageEvent event,
    Emitter<WakiliState> emit,
  ) async {
    final current = _extractChatData(state);

    final userMessage = ChatMessage(
      id: _uuid.v4(),
      content: event.message,
      isUser: true,
      timestamp: DateTime.now(),
    );

    final List<ChatMessage> messagesWithUserAndAiPlaceholder =
        List<ChatMessage>.from(current.messages);
    messagesWithUserAndAiPlaceholder.add(userMessage);

    final ChatMessage aiMessagePlaceholder = ChatMessage(
      id: _uuid.v4(),
      content: '',
      isUser: false,
      timestamp: DateTime.now(),
    );
    messagesWithUserAndAiPlaceholder.add(aiMessagePlaceholder);

    emit(WakiliChatLoaded(
      messages: messagesWithUserAndAiPlaceholder,
      isLoading: true,
      selectedCategory: current.category,
      allCategories: current.allCategories,
      error: null,
    ));

    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid == null) {
      emit(WakiliChatErrorState(
        message: 'You must be logged in to save conversations.',
        messages: messagesWithUserAndAiPlaceholder,
        selectedCategory: current.category,
        allCategories: current.allCategories,
      ));
      return;
    }

    
    _currentConversationId ??= _uuid.v4();

    String fullBotResponse = '';
    await emit.forEach<Either<Failure, String>>(
      _sendStreamMessage(
        event.message,
        conversationHistory:
            messagesWithUserAndAiPlaceholder,
      ),
      onData: (either) {
        return either.fold(
          (failure) {
            return WakiliChatErrorState(
              message: _mapFailureToMessage(failure),
              messages: messagesWithUserAndAiPlaceholder,
              selectedCategory: current.category,
              allCategories: current.allCategories,
            );
          },
          (chunk) {
            fullBotResponse += chunk;
            final List<ChatMessage> updatedMessages =
                List<ChatMessage>.from(messagesWithUserAndAiPlaceholder);

            final int index = updatedMessages
                .indexWhere((msg) => msg.id == aiMessagePlaceholder.id);

            if (index != -1) {
              updatedMessages[index] =
                  updatedMessages[index].copyWith(content: fullBotResponse);
            } else {
              updatedMessages.add(ChatMessage(
                id: _uuid
                    .v4(), 
                content: fullBotResponse,
                isUser: false,
                timestamp: DateTime.now(),
              ));
            }

            return WakiliChatLoaded(
              messages: updatedMessages,
              isLoading: true, 
              selectedCategory: current.category,
              allCategories: current.allCategories,
              error: null,
            );
          },
        );
      },
      onError: (error, stackTrace) {
        final Failure failure = _mapErrorToFailure(error);
        return WakiliChatErrorState(
          message: _mapFailureToMessage(failure),
          messages:
              messagesWithUserAndAiPlaceholder,
          selectedCategory: current.category,
          allCategories: current.allCategories,
        );
      },
    );


    _chatHistoryBloc.add(SaveCurrentConversation(
      userId: currentUserUid,
      category: current.category ?? 'General',
      messages: (state as WakiliChatLoaded)
          .messages,
      conversationId:
          _currentConversationId, 
    ));


    if (state is WakiliChatLoaded) {
      emit((state as WakiliChatLoaded).copyWith(isLoading: false));
    }
  }

  FutureOr<void> _onSaveCurrentChatEvent(
      SaveCurrentChatEvent event, Emitter<WakiliState> emit) async {
    final current = _extractChatData(state);
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

    if (currentUserUid != null && current.messages.isNotEmpty) {
      _currentConversationId ??= _uuid.v4();

      _chatHistoryBloc.add(SaveCurrentConversation(
        userId: currentUserUid,
        category: current.category ?? 'General',
        messages: current.messages,
        conversationId: _currentConversationId,
      ));
    }
  }

  FutureOr<void> _onClearChat(
      ClearChatEvent event, Emitter<WakiliState> emit) async {
    final current = _extractChatData(state);
    final currentUserUid = FirebaseAuth.instance.currentUser?.uid;

  
    if (currentUserUid != null &&
        current.messages.isNotEmpty &&
        _currentConversationId != null) {
      _chatHistoryBloc.add(SaveCurrentConversation(
        userId: currentUserUid,
        category: current.category ?? 'General',
        messages: current.messages,
        conversationId:
            _currentConversationId, 
      ));
    }

    _currentConversationId =
        null; 
    emit(WakiliChatLoaded(
      messages: const [],
      selectedCategory: (state is WakiliChatLoaded)
          ? (state as WakiliChatLoaded).selectedCategory
          : null,
      allCategories: (state is WakiliChatLoaded)
          ? (state as WakiliChatLoaded).allCategories
          : const [],
      isLoading: false,
    ));
  }

  void _onSetCategoryContext(
    SetCategoryContextEvent event,
    Emitter<WakiliState> emit,
  ) {
    final current = _extractChatData(state);
    emit(WakiliChatLoaded(
      messages: current.messages,
      selectedCategory: event.category,
      allCategories: current.allCategories,
      isLoading: current.messages.isEmpty
          ? false
          : false, 
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
      allCategories: current.allCategories,
      isLoading: current.messages.isEmpty
          ? false 
          : false, 
    ));
  }

  FutureOr<void> _onLoadExistingChat(
    LoadExistingChat event,
    Emitter<WakiliState> emit,
  ) async {
    _currentConversationId =
        event.conversationId; 

    final current = _extractChatData(state); 
    emit(WakiliChatLoaded(
      messages: event.messages,
      isLoading: false,
      selectedCategory: current.category, 
      allCategories: current.allCategories,
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

  FutureOr<void> _onLoadExistingChatWithCategory(
    LoadExistingChatWithCategory event,
    Emitter<WakiliState> emit,
  ) async {
    _currentConversationId =
        event.conversationId; 
    final current = _extractChatData(state);

    emit(WakiliChatLoaded(
      messages: event.messages,
      selectedCategory: event.category,
      isLoading: false,
      allCategories: current.allCategories, 
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
