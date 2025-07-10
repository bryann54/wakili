import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';

abstract class WakiliChatRepository {
  Future<Either<Failure, String>> sendMessage(String message);
  Stream<Either<Failure, String>> sendMessageStream(String message);
}