part of 'wakili_bloc.dart';

abstract class WakiliEvent extends Equatable {
  const WakiliEvent();

  @override
  List<Object> get props => [];
}

class SendMessageEvent extends WakiliEvent {
  final String message;

  const SendMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class SendStreamMessageEvent extends WakiliEvent {
  final String message;

  const SendStreamMessageEvent(this.message);

  @override
  List<Object> get props => [message];
}

class ClearChatEvent extends WakiliEvent {
  const ClearChatEvent();
}

class SetCategoryContextEvent extends WakiliEvent {
  final String category;

  const SetCategoryContextEvent(this.category);

  @override
  List<Object> get props => [category];
}

class ClearCategoryContextEvent extends WakiliEvent {
  const ClearCategoryContextEvent();

  @override
  List<Object> get props => [];
}

class LoadExistingChat extends WakiliEvent {
  final List<ChatMessage> messages;

  const LoadExistingChat(this.messages);

  @override
  List<Object> get props => [messages];
}

class LoadExistingChatWithCategory extends WakiliEvent {
  final List<ChatMessage> messages;
  final String category;

  const LoadExistingChatWithCategory(this.messages, this.category);

  @override
  List<Object> get props => [messages, category];
}
