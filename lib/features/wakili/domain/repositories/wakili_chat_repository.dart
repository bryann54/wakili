abstract class WakiliChatRepository {
  Future<String> sendMessage(String message);
  Stream<String> sendMessageStream(String message);
}
