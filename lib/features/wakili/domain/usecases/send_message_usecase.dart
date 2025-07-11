import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import '../repositories/wakili_chat_repository.dart';

@injectable
class SendMessageStreamUseCase {
  final WakiliChatRepository _repository;

  SendMessageStreamUseCase(this._repository);

  Stream<Either<Failure, String>> call(String message, {
    List<ChatMessage>? conversationHistory,
  }) {
    if (message.trim().isEmpty) {
      return Stream.value(left(ValidationFailure('Message cannot be empty')));
    }
    return _repository.sendMessageStream(message,
      conversationHistory: conversationHistory,
    );
  }
}
