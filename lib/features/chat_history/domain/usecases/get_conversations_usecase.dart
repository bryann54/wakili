import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';

@injectable
class GetConversationsUseCase
    implements UseCase<List<Map<String, dynamic>>, String> {
  final ChatHistoryRepository _repository;

  GetConversationsUseCase(this._repository);

  @override
  Future<Either<Failure, List<Map<String, dynamic>>>> call(String userId) {
    return _repository.getConversations(userId);
  }
}
