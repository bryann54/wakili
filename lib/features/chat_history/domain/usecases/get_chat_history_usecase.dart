import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class GetChatHistoryUseCase {
  final ChatHistoryRepository _repository;

  GetChatHistoryUseCase(this._repository);

  Future<List<ChatConversation>> call() {
    return _repository.getChatHistory();
  }
}
