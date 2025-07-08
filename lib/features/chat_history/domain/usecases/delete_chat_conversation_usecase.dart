import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class DeleteChatConversationUseCase {
  final ChatHistoryRepository _repository;

  DeleteChatConversationUseCase(this._repository);

  Future<Either<Failure, Unit>> call(String conversationId) {
    return _repository.deleteChatConversation(conversationId);
  }
}
