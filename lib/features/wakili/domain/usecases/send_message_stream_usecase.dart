import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import '../repositories/wakili_chat_repository.dart';

@injectable
class SendMessageUseCase implements UseCase<String, String> {
  final WakiliChatRepository _repository;

  SendMessageUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(String message) {
    if (message.trim().isEmpty) {
      return Future.value(left(ValidationFailure('Message cannot be empty')));
    }
    return _repository.sendMessage(message);
  }
}
