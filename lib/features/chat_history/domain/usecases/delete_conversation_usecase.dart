import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class DeleteConversationUseCase implements UseCase<void, String> {
  final ChatHistoryRepository _repository;

  DeleteConversationUseCase(this._repository);

  @override
  Future<Either<Failure, void>> call(String conversationId) {
    return _repository.deleteConversation(conversationId);
  }
}
