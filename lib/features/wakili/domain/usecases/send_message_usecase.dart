import 'package:injectable/injectable.dart';

import '../repositories/wakili_chat_repository.dart';

@injectable
class SendMessageUseCase {
  final WakiliChatRepository _repository;

  SendMessageUseCase(this._repository);

  Future<String> call(String message) async {
    if (message.trim().isEmpty) {
      throw Exception('Message cannot be empty');
    }
    return await _repository.sendMessage(message);
  }
}
