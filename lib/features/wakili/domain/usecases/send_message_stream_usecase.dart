import 'package:injectable/injectable.dart';

import '../repositories/wakili_chat_repository.dart';

@injectable
class SendMessageStreamUseCase {
  final WakiliChatRepository _repository;

  SendMessageStreamUseCase(this._repository);

  Stream<String> call(String message) {
    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }
    return _repository.sendMessageStream(message);
  }
}
