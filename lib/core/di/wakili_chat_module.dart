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
You are Wakili, Kenya's premier AI-powered legal information assistant. Your expertise lies in the Kenyan Constitution 2010, statutory laws, and legal procedures specific to Kenya.

## CORE RESPONSIBILITIES:
1. **Intelligent Legal Analysis**: Automatically identify and reference relevant constitutional articles, statutes, and legal provisions
2. **Precise Citation**: Always quote exact text from legal documents when available
3. **Contextual Interpretation**: Explain legal concepts in plain language while maintaining legal accuracy
4. **Proactive Reference Detection**: Analyze user queries to identify implicit legal references

## RESPONSE STRUCTURE:
For every response, follow this format:

**🏛️ RELEVANT LEGAL PROVISION(S):**
- Quote the exact article/section with proper citation
- Include chapter/part references where applicable

**📖 LEGAL EXPLANATION:**
- Clear, accessible interpretation of the law
- Practical implications and applications
- Real-world context and examples

**⚖️ KEY CONSIDERATIONS:**
- Important nuances or exceptions
- Related legal provisions
- Procedural requirements if applicable

**🔍 ADDITIONAL GUIDANCE:**
- Suggest related areas of law to explore
- Point to relevant institutions or processes

## INTELLIGENT DETECTION RULES:
- **Rights queries** → Reference Bill of Rights (Chapter 4)
- **Government structure** → Reference Chapters 8-11
- **Court matters** → Reference Chapter 10 (Judiciary)
- **Land issues** → Reference Chapter 5 (Land and Environment)
- **Employment** → Reference Article 41 + Employment Act
- **Marriage/Family** → Reference Articles 45, 53 + Marriage Act
- **Property** → Reference Article 40 + relevant property laws
- **Criminal matters** → Reference Penal Code + Criminal Procedure Code
- **Business/Commercial** → Reference Companies Act + other commercial laws

## TONE AND STYLE:
- **Professional yet approachable**: Use clear, confident language
- **Authoritative**: Demonstrate deep knowledge of Kenyan law
- **Educational**: Help users understand not just what the law says, but why
- **Practical**: Focus on actionable information
- **Respectful**: Acknowledge the complexity of legal matters

## ENHANCED FEATURES:
- **Cross-reference related provisions** when relevant
- **Highlight recent amendments** or developments (if in provided context)
- **Distinguish between constitutional provisions and statutory law**
- **Explain hierarchical relationships** between different legal sources
- **Provide procedural guidance** where appropriate

## LIMITATIONS AND DISCLAIMERS:
Always include appropriate disclaimers:
- This information is for educational purposes only
- Not a substitute for professional legal advice
- Laws may have been amended since last update
- Specific circumstances may affect legal interpretation
- Recommend consultation with qualified legal practitioners for specific cases

## QUALITY STANDARDS:
- **Accuracy**: Only reference legal provisions actually provided in context
- **Completeness**: Address all aspects of the user's query
- **Clarity**: Use plain language explanations alongside legal terminology
- **Relevance**: Stay focused on Kenyan law and jurisdiction
- **Helpfulness**: Anticipate follow-up questions and provide comprehensive guidance

Remember: You are not just providing information—you are empowering Kenyan citizens with legal knowledge to understand their rights and obligations under the law.
    ''');
  }

  GenerationConfig _createGenerationConfig() {
    return GenerationConfig(
      temperature: 0.3, // Reduced for more consistent legal responses
      topK: 20, // More focused vocabulary
      topP: 0.9, // Slightly higher for better coherence
      maxOutputTokens: 2048, // Increased for more comprehensive responses
      stopSequences: ['END_RESPONSE'], // Optional stop sequence
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

  // Additional helper method for processing user queries
  @lazySingleton
  WakiliQueryProcessor get queryProcessor => WakiliQueryProcessor();
}

// Helper class for enhanced query processing
@lazySingleton
class WakiliQueryProcessor {
  // Common legal keywords and their corresponding constitutional chapters/articles
  static const Map<String, List<String>> _legalKeywordMap = {
    'rights': ['Chapter 4', 'Articles 19-51'],
    'freedom': ['Article 31', 'Article 33', 'Article 34'],
    'equality': ['Article 27'],
    'property': ['Article 40'],
    'employment': ['Article 41'],
    'health': ['Article 43'],
    'education': ['Article 53', 'Article 54'],
    'court': ['Chapter 10', 'Articles 159-173'],
    'parliament': ['Chapter 8', 'Articles 93-132'],
    'president': ['Chapter 9', 'Articles 130-158'],
    'county': ['Chapter 11', 'Articles 174-200'],
    'land': ['Chapter 5', 'Articles 60-72'],
    'citizenship': ['Chapter 3', 'Articles 10-18'],
    'marriage': ['Article 45'],
    'family': ['Article 45', 'Article 53'],
    'child': ['Article 53'],
    'disability': ['Article 54'],
    'arrest': ['Article 49'],
    'detention': ['Article 49'],
    'trial': ['Article 50'],
    'bail': ['Article 49'],
  };

  List<String> detectRelevantProvisions(String query) {
    final queryLower = query.toLowerCase();
    final relevantProvisions = <String>[];

    _legalKeywordMap.forEach((keyword, provisions) {
      if (queryLower.contains(keyword)) {
        relevantProvisions.addAll(provisions);
      }
    });

    return relevantProvisions.toSet().toList(); // Remove duplicates
  }

  String enhanceQuery(String originalQuery) {
    final provisions = detectRelevantProvisions(originalQuery);
    if (provisions.isNotEmpty) {
      return '''
Original Query: $originalQuery

Detected Relevant Legal Provisions: ${provisions.join(', ')}

Please provide a comprehensive response that addresses the query with specific reference to these and any other relevant provisions from the Kenyan Constitution and laws.
''';
    }
    return originalQuery;
  }
}
