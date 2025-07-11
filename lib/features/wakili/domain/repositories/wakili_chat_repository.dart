import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

abstract class WakiliChatRepository {
  Future<Either<Failure, String>> sendMessage(
    String message, {
    List<ChatMessage>? conversationHistory,
  });

  Stream<Either<Failure, String>> sendMessageStream(
    String message, {
    List<ChatMessage>? conversationHistory,
  });
}
