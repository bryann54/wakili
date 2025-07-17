import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@injectable
class SaveConversationUseCase
    implements UseCase<String, SaveConversationParams> {
  final ChatHistoryRepository _repository;

  SaveConversationUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(SaveConversationParams params) {
    return _repository.saveConversation(
      userId: params.userId,
      category: params.category,
      messages: params.messages,
      conversationId: params.conversationId,
    );
  }
}

class SaveConversationParams {
  final String userId;
  final String category;
  final List<ChatMessage> messages;
  final String? conversationId;
  final String? title;

  SaveConversationParams({
    required this.userId,
    required this.category,
    required this.messages,
    this.conversationId,
    this.title,
  });
  List<Object?> get props =>
      [userId, category, messages, conversationId, title];
}
