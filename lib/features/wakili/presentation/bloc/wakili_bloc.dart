import 'dart:async';
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

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessage;
  final SendMessageStreamUseCase _sendStreamMessage;
  final ChatHistoryBloc _chatHistoryBloc;
  final GetLegalCategoriesUseCase _getLegalCategories;

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
        message: _mapFailure(failure),
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

  FutureOr<void> _onSendStreamMessage(
    SendStreamMessageEvent event,
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

    final aiId = DateTime.now().millisecondsSinceEpoch.toString();
    String accumulated = '';

    await for (final chunk in _sendStreamMessage(
      contextMessage,
      conversationHistory: current.messages,
    )) {
      chunk.fold(
        (failure) {
          emit(WakiliChatErrorState(
            message: _mapFailure(failure),
            messages: [...current.messages, userMessage],
            selectedCategory: current.category,
          ));
        },
        (chunkContent) {
          accumulated += chunkContent;
          final aiMessage = ChatMessage(
            id: aiId,
            content: accumulated,
            isUser: false,
            timestamp: DateTime.now(),
          );

          final updated = [...current.messages, userMessage];
          final existingIndex = updated.indexWhere((m) => m.id == aiId);
          if (existingIndex != -1) {
            updated[existingIndex] = aiMessage;
          } else {
            updated.add(aiMessage);
          }

          emit(WakiliChatLoaded(
            messages: updated,
            isLoading: true,
            selectedCategory: current.category,
          ));
        },
      );
    }

    if (state is WakiliChatLoaded) {
      emit((state as WakiliChatLoaded).copyWith(isLoading: false));
    }
  }

  void _onClearChat(ClearChatEvent event, Emitter<WakiliState> emit) {
    final current = _extractChatData(state);

    if (current.messages.isNotEmpty) {
      _chatHistoryBloc.add(SaveCurrentChatConversation(current.messages));
    }

    emit(WakiliChatLoaded(
      messages: [],
      selectedCategory: current.category,
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
        message: _mapFailure(failure),
        messages: current.messages,
        selectedCategory: current.category,
        allCategories:
            current.allCategories, // Retain existing categories if any
      )),
      (categories) {
        emit(WakiliChatLoaded(
          messages: current.messages,
          isLoading: false,
          selectedCategory: current.category,
          allCategories: categories, // Set the fetched categories
        ));
      },
    );
  }

  void _onLoadExistingChatWithCategory(
    LoadExistingChatWithCategory event,
    Emitter<WakiliState> emit,
  ) {
    emit(WakiliChatLoaded(
      messages: event.messages,
      selectedCategory: event.category,
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

  String _mapFailure(Failure failure) {
    if (failure is ValidationFailure) return failure.message;
    return 'Something went wrong';
  }
}
