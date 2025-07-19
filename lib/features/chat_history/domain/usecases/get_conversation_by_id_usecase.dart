import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class GetConversationByIdUseCase
    implements UseCase<Map<String, dynamic>?, String> {
  final ChatHistoryRepository _repository;

  GetConversationByIdUseCase(this._repository);

  @override
  Future<Either<Failure, Map<String, dynamic>?>> call(String conversationId) {
    return _repository.getConversationById(conversationId);
  }
}
