import 'package:dartz/dartz.dart';
import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';

abstract class WakiliChatRepository {
  Future<Either<Failure, NoParams>> sendMessage(String message);
  Stream<Either<Failure, NoParams>> sendMessageStream(String message);
}
