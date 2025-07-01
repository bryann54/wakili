import 'package:injectable/injectable.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class DeleteChatConversationUseCase {
  final ChatHistoryRepository _repository;

  DeleteChatConversationUseCase(this._repository);

  Future<void> call(String conversationId) {
    return _repository.deleteChatConversation(conversationId);
  }
}
