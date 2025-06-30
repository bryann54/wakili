import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

@module
abstract class WakiliChatModule {
  @lazySingleton
  String get _geminiApiKey { 
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception('GEMINI_API_KEY not found in .env file or is empty. '
                       'Ensure .env is loaded and key is present.');
    }
    return apiKey;
  }


  @lazySingleton
  GenerativeModel get generativeModel {
    return GenerativeModel(
      model: 'gemini-1.5-flash', 
      apiKey: _geminiApiKey, 
      systemInstruction: _createSystemInstruction(),
      generationConfig: _createGenerationConfig(),
      safetySettings: _createSafetySettings(),
    );
  }

  Content _createSystemInstruction() {
    return Content.system('''
      You are Wakili, an AI-powered legal information assistant for Kenyan citizens.
      Your purpose is to provide clear, simplified explanations of legal rights and procedures based on the Kenyan Constitution and other relevant laws.
      You MUST always provide information grounded ONLY in the specific legal texts provided to you as context (this context will be injected into the prompt by the backend, not directly by this instruction).
      Do NOT offer personal legal advice, opinions, or solutions.
      Always include clear disclaimers that your information is for general guidance and not legal advice, and that users should consult a professional lawyer for specific cases.
      When referring to articles, quote them accurately or paraphrase closely.
      Maintain a formal, helpful, and objective tone.
      If a query cannot be answered with the provided legal context, state clearly that you cannot provide specific details based on the available information.
    ''');
  }

  GenerationConfig _createGenerationConfig() {
    return GenerationConfig(
      temperature: 0.7,
      topK: 40,
      topP: 0.8,
      maxOutputTokens: 1024,
    );
  }

  List<SafetySetting> _createSafetySettings() {
    return [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
    ];
  }
}