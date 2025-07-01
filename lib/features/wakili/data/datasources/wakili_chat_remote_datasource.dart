import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';

abstract class WakiliChatRemoteDataSource {
  Future<String> sendMessage(String message);
  Stream<String> sendMessageStream(String message);
}

@LazySingleton(as: WakiliChatRemoteDataSource)
class GeminiWakiliChatRemoteDataSource implements WakiliChatRemoteDataSource {
  final GenerativeModel _model;

  GeminiWakiliChatRemoteDataSource(this._model);

  @override
  Future<String> sendMessage(String message) async {
    try {
      final content = [Content.text(message)];
      final response = await _model.generateContent(content);

      if (response.text == null || response.text!.isEmpty) {
        throw Exception('Received empty response from Gemini');
      }

      return response.text!;
    } catch (e) {
      throw Exception('Failed to get response from Wakili: ${e.toString()}');
    }
  }

  @override
  Stream<String> sendMessageStream(String message) async* {
    try {
      final content = [Content.text(message)];
      final stream = _model.generateContentStream(content);

      await for (final chunk in stream) {
        if (chunk.text != null && chunk.text!.isNotEmpty) {
          yield chunk.text!;
        }
      }
    } catch (e) {
      throw Exception(
          'Failed to get streaming response from Wakili: ${e.toString()}');
    }
  }
}
