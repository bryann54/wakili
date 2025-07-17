import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/chat_history/domain/repositories/chat_history_repository.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';
import 'package:wakili/features/chat_history/data/models/chat_conversation.dart'; // Import the ChatConversation model

@injectable
class SaveConversationUseCase
    implements UseCase<String, SaveConversationParams> {
  final ChatHistoryRepository _repository;

  SaveConversationUseCase(this._repository);

  @override
  Future<Either<Failure, String>> call(SaveConversationParams params) {
    final String conversationId =
        params.conversationId ?? ChatConversation.generateUniqueId();
    final String conversationTitle = params.title ??
        (params.messages.isNotEmpty
            ? params.messages.first.content.split(' ').take(5).join(' ')
            : 'New Chat');
    final ChatConversation conversationToSave = ChatConversation(
      id: conversationId,
      userId: params.userId,
      category: params.category,
      messages: params.messages,
      title: conversationTitle,
      timestamp: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      tags: [],
      isArchived: false,
      isFavorite: false,
      summary: null,
      messageCount: params.messages.length,
      searchKeywords: ChatConversation.generateSearchKeywords(
          params.messages, conversationTitle),
    );
    return _repository.saveConversation(
      conversation: conversationToSave,
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

  // Note: Equatable's props are usually for value equality, not strictly necessary here
  // but if you are using it elsewhere, ensure all relevant fields are included.
  List<Object?> get props =>
      [userId, category, messages, conversationId, title];
}
