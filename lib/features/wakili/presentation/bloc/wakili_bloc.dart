import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/presentation/bloc/chat_history_bloc.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_usecase.dart';
import 'package:wakili/features/wakili/domain/usecases/send_message_stream_usecase.dart';

part 'wakili_event.dart';
part 'wakili_state.dart';

@injectable
class WakiliBloc extends Bloc<WakiliEvent, WakiliState> {
  final SendMessageUseCase _sendMessage;
  final SendMessageStreamUseCase _sendStreamMessage;
  final ChatHistoryBloc _chatHistoryBloc;

  WakiliBloc(
    this._sendMessage,
    this._sendStreamMessage,
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

    final result = await _sendMessage(contextMessage);
    result.fold(
      (failure) => emit(WakiliChatErrorState(
        message: _mapFailure(failure),
        messages: [...current.messages, userMessage],
        selectedCategory: current.category,
      )),
      (_) {
        final aiMessage = ChatMessage(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          content: _.toString(),
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

    await for (final chunk in _sendStreamMessage(contextMessage)) {
      chunk.fold(
        (failure) {
          emit(WakiliChatErrorState(
            message: _mapFailure(failure),
            messages: [...current.messages, userMessage],
            selectedCategory: current.category,
          ));
        },
        (_) {
          accumulated += _.toString();
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

  void _onLoadExistingChatWithCategory(
    LoadExistingChatWithCategory event,
    Emitter<WakiliState> emit,
  ) {
    emit(WakiliChatLoaded(
      messages: event.messages,
      selectedCategory: event.category,
    ));
  }

  ({List<ChatMessage> messages, String? category}) _extractChatData(
      WakiliState state) {
    if (state is WakiliChatLoaded) {
      return (messages: state.messages, category: state.selectedCategory);
    } else if (state is WakiliChatErrorState) {
      return (messages: state.messages, category: state.selectedCategory);
    } else {
      return (messages: [], category: null);
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
