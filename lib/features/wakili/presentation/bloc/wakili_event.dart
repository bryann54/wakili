part of 'wakili_bloc.dart';


abstract class WakiliEvent extends Equatable {
  const WakiliEvent();
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
class WakiliChatErrorState extends WakiliState {
  final String message;
  final List<ChatMessage>
      messages; 

  const WakiliChatErrorState({required this.message, required this.messages});

  @override
  List<Object?> get props => [message, messages];
}
class ClearChatEvent extends WakiliEvent {
  @override
  List<Object> get props => [];
}