import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/di/wakili_chat_module.dart';
import 'package:wakili/features/wakili/data/models/chat_message.dart';

@injectable
class WakiliChatRemoteDataSource {
  final GenerativeModel _model;
  final WakiliQueryProcessor _queryProcessor;

  WakiliChatRemoteDataSource(this._model, this._queryProcessor);

  Future<String> sendMessage(
    String message, {
    List<ChatMessage>? conversationHistory,
  }) async {
    try {
      final enhancedQuery =
          await _queryProcessor.enhanceQueryWithContext(message);

      final chatSession = _model.startChat(
        history: _buildChatHistory(conversationHistory),
      );

      final response = await chatSession.sendMessage(
        Content.text(enhancedQuery),
      );

      return response.text ?? 'No response generated';
    } catch (e) {
      throw Exception('Failed to send message: $e');
    }
  }

  Stream<String> sendMessageStream(
    String message, {
    List<ChatMessage>? conversationHistory,
  }) async* {
    try {
      final enhancedQuery =
          await _queryProcessor.enhanceQueryWithContext(message);

      // Create chat session with conversation history
      final chatSession = _model.startChat(
        history: _buildChatHistory(conversationHistory),
      );

      final response = chatSession.sendMessageStream(
        Content.text(enhancedQuery),
      );

      await for (final chunk in response) {
        if (chunk.text != null) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      throw Exception('Failed to send message stream: $e');
    }
  }

// In _buildChatHistory method, you can limit history:
  List<Content> _buildChatHistory(List<ChatMessage>? messages) {
    if (messages == null || messages.isEmpty) {
      return [];
    }

    // Keep only last 20 messages
    final recentMessages = messages.length > 20
        ? messages.sublist(messages.length - 20)
        : messages;

    final history = <Content>[];

    for (final message in recentMessages) {
      if (message.isUser) {
        history.add(Content.text(message.content));
      } else {
        history.add(Content.model([TextPart(message.content)]));
      }
    }

    return history;
  }
}
