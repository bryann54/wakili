import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import '../repositories/wakili_chat_repository.dart';

@injectable
class SendMessageStreamUseCase {
  final WakiliChatRepository _repository;

  SendMessageStreamUseCase(this._repository);

  Stream<Either<Failure, String>> call(String message) {
    if (message.trim().isEmpty) {
      return Stream.value(left(ValidationFailure('Message cannot be empty')));
    }
    return _repository.sendMessageStream(message);
  }
}
