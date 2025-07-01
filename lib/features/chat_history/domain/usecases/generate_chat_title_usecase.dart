import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/datasources/wakili_chat_remote_datasource.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@injectable
class GenerateChatTitleUseCase {
  final WakiliChatRemoteDataSource _remoteDataSource;

  GenerateChatTitleUseCase(this._remoteDataSource);

  Future<String> call(List<ChatMessage> messages) async {
    if (messages.isEmpty) {
      return "Empty Chat";
    }

    // Construct a prompt for the AI to generate a title
    String conversationSnippet = messages
        .where((msg) => !msg.isUser) // Focus on AI responses for title
        .take(5) // Take first 5 AI messages
        .map((msg) => msg.content)
        .join(" ");

    if (conversationSnippet.length > 200) {
      conversationSnippet = conversationSnippet.substring(0, 200);
    }

    final prompt =
        "Summarize the following legal conversation into a very short, concise title (max 5 words). Do not include any introductory phrases like 'The title is:' or 'Summary:':\n\n\"$conversationSnippet\"";

    try {
      final title = await _remoteDataSource.sendMessage(prompt);
      // Clean up the title from any extra quotes or newlines
      return title.replaceAll(RegExp(r'["\n\r]'), '').trim();
    } catch (e) {
      print("Error generating chat title: $e");
      return "Untitled Chat - ${DateTime.now().hour}:${DateTime.now().minute}";
    }
  }
}
