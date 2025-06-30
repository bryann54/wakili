import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/datasources/wakili_chat_remote_datasource.dart';
import 'package:wakili/features/wakili/domain/repositories/wakili_chat_repository.dart';

@LazySingleton(as: WakiliChatRepository)
class WakiliChatRepositoryImpl implements WakiliChatRepository {
  final WakiliChatRemoteDataSource _remoteDataSource;

  WakiliChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<String> sendMessage(String message) async {
    return await _remoteDataSource.sendMessage(message);
  }

  @override
  Stream<String> sendMessageStream(String message) {
    return _remoteDataSource.sendMessageStream(message);
  }
}
