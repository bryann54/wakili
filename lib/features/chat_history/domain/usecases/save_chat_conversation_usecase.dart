import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class SaveChatConversationUseCase {
  final ChatHistoryRepository _repository;

  SaveChatConversationUseCase(this._repository);

  Future<Either<Failure, Unit>> call(ChatConversation conversation) {
    return _repository.saveChatConversation(conversation);
  }
}
