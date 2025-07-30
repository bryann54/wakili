import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:wakili/core/chat/wakili_chat_models.dart';

class ConversationManager {
  ConversationManager();
  final Map<String, List<Content>> _conversations = {};

  void addMessage(String sessionId, Content message) {
    _conversations[sessionId] ??= [];
    _conversations[sessionId]!.add(message);

    const maxHistoryLength = 20;
    if (_conversations[sessionId]!.length > maxHistoryLength) {
      _conversations[sessionId]!
          .removeRange(0, _conversations[sessionId]!.length - maxHistoryLength);
    }
  }

  List<Content> getConversationHistory(String sessionId) {
    return _conversations[sessionId] ?? [];
  }

  void clearConversation(String sessionId) {
    _conversations[sessionId]?.clear();
  }
}

@lazySingleton
class WakiliQueryProcessor {
  WakiliQueryProcessor();

  static const Map<String, WakiliContext> _legalContextMap = {
    'rights': WakiliContext(
      provisions: ['Chapter 4', 'Articles 19-51'],
      practicalContext:
          'civil liberties, human rights violations, constitutional petition',
      commonScenarios: [
        'police harassment',
        'discrimination',
        'freedom of expression',
        'data privacy',
        'right to information'
      ],
      shengTerms: ['haki', 'uwazi', 'polisi'],
    ),
    'employment': WakiliContext(
      provisions: ['Article 41', 'Employment Act 2007'],
      practicalContext: 'workplace disputes, unfair dismissal, salary issues',
      commonScenarios: [
        'wrongful termination',
        'unpaid wages',
        'workplace harassment',
        'retrenchment',
        'maternity leave'
      ],
      shengTerms: ['kazi', 'mshahara', 'boss'],
    ),
    'property': WakiliContext(
      provisions: ['Article 40', 'Land Act 2012', 'Land Registration Act 2012'],
      practicalContext:
          'property disputes, land grabbing, inheritance, titling',
      commonScenarios: [
        'boundary disputes',
        'illegal eviction',
        'property inheritance',
        'land fraud',
        'title deed process',
        'rent disputes'
      ],
      shengTerms: ['nyumba', 'plot', 'rent'],
    ),
    'family': WakiliContext(
      provisions: ['Article 45', 'Marriage Act 2014', 'Children Act 2001'],
      practicalContext:
          'marriage, divorce, child custody, maintenance, adoption',
      commonScenarios: [
        'divorce proceedings',
        'child support',
        'custody battles',
        'domestic violence',
        'succession planning'
      ],
      shengTerms: ['ndoa', 'watoto', 'familia'],
    ),
    'criminal': WakiliContext(
      provisions: ['Article 49-50', 'Criminal Procedure Code', 'Penal Code'],
      practicalContext:
          'arrest procedures, bail, criminal defense, police interaction',
      commonScenarios: [
        'police arrest',
        'bail application',
        'criminal charges',
        'rights during arrest',
        'plea bargaining'
      ],
      shengTerms: ['polisi', 'korti'],
    ),
    'business': WakiliContext(
      provisions: ['Companies Act 2015', 'Competition Act', 'Insolvency Act'],
      practicalContext:
          'business registration, compliance, commercial disputes, startups',
      commonScenarios: [
        'company formation',
        'contract disputes',
        'licensing',
        'startup legal advice',
        'intellectual property'
      ],
      shengTerms: ['biashara', 'hustle'],
    ),
  };

  // Enhanced language detection
  String detectPrimaryLanguage(String query) {
    final queryLower = query.trim().toLowerCase();

    // Common Swahili/Sheng words
    final swahiliIndicators = [
      'niaje',
      'mambo',
      'poa',
      'sawa',
      'shida',
      'una',
      'kuna',
      'nina',
      'je',
      'nini',
      'vipi',
      'kwani',
      'lakini',
      'ama',
      'au',
      'na',
      'ya',
      'za',
      'wa',
      'la',
      'cha',
      'vya',
      'pa',
      'ku',
      'mu',
      'ndio',
      'hapana',
      'sijui',
      'najua',
      'nataka',
      'naweza'
    ];

    // Common English words
    final englishIndicators = [
      'the',
      'is',
      'are',
      'can',
      'what',
      'how',
      'when',
      'where',
      'why',
      'do',
      'does',
      'will',
      'would',
      'should',
      'could',
      'have',
      'has',
      'about',
      'with',
      'from',
      'they',
      'this',
      'that',
      'there'
    ];

    final words = queryLower.split(RegExp(r'\s+'));
    int swahiliScore = 0;
    int englishScore = 0;

    for (final word in words) {
      if (swahiliIndicators.contains(word)) {
        swahiliScore += 2; // Higher weight for clear indicators
      }
      if (englishIndicators.contains(word)) {
        englishScore += 2;
      }
    }

    // Check for common greetings
    if (queryLower.startsWith('niaje') ||
        queryLower.startsWith('mambo') ||
        queryLower.startsWith('sema') ||
        queryLower.contains('habari')) {
      return 'swahili';
    }

    if (queryLower.startsWith('hello') ||
        queryLower.startsWith('hi') ||
        queryLower.startsWith('hey')) {
      return 'english';
    }

    return swahiliScore > englishScore ? 'swahili' : 'english';
  }

  bool isSimpleGreeting(String query) {
    final greetings = [
      'hello',
      'hi',
      'hey',
      'niaje',
      'mambo',
      'sema',
      'habari',
      'good morning',
      'good afternoon',
      'good evening'
    ];

    final queryLower = query.trim().toLowerCase();
    return greetings.any((greeting) =>
        queryLower == greeting || queryLower.startsWith('$greeting '));
  }

  EmotionalContext detectEmotionalContext(String query) {
    final queryLower = query.toLowerCase();

    if (queryLower
        .contains(RegExp(r'(emergency|urgent|haraka|nimesumbuka|nimekwama)'))) {
      return EmotionalContext.stressed;
    }
    if (queryLower
        .contains(RegExp(r'(frustrated|angry|annoyed|nimechoka|haieleweki)'))) {
      return EmotionalContext.frustrated;
    }
    if (queryLower
        .contains(RegExp(r'(confused|sijui|sielewi|help|vipi|mbona)'))) {
      return EmotionalContext.confused;
    }
    if (queryLower
        .contains(RegExp(r'(mambo|niaje|poa|sema|cool|salama|hi|hey)'))) {
      return EmotionalContext.casual;
    }
    return EmotionalContext.neutral;
  }

  WakiliContext? detectLegalContext(String query) {
    final queryLower = query.toLowerCase();

    for (final entry in _legalContextMap.entries) {
      if (queryLower.contains(entry.key) ||
          entry.value.commonScenarios
              .any((scenario) => queryLower.contains(scenario.toLowerCase())) ||
          entry.value.shengTerms
              .any((term) => queryLower.contains(term.toLowerCase()))) {
        return entry.value;
      }
    }
    return null;
  }

  Future<String> enhanceQueryWithContext(String originalQuery) async {
    final primaryLanguage = detectPrimaryLanguage(originalQuery);
    final isGreeting = isSimpleGreeting(originalQuery);
    final context = detectLegalContext(originalQuery);
    final emotionalContext = detectEmotionalContext(originalQuery);

    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy, h:mm:ss a');
    final formattedDate = dateFormatter.format(now);

    String webKnowledge = '';
    if (!isGreeting && context != null) {
      webKnowledge = await fetchWebKnowledge(
          "${context.commonScenarios.first} Kenya latest news");
    }

    return '''
User Query: $originalQuery
Primary Language Detected: $primaryLanguage
Is Simple Greeting: $isGreeting
Current Date: $formattedDate
Emotional Context: ${emotionalContext.name}
${context != null ? 'Legal Context: ${context.practicalContext}' : ''}
${webKnowledge.isNotEmpty ? 'Recent Info: $webKnowledge' : ''}

RESPONSE INSTRUCTIONS:
1. Respond ONLY in $primaryLanguage (no mixing languages)
2. ${isGreeting ? 'Simple greeting response only - no legal advice' : 'Provide comprehensive legal guidance'}
3. Start directly - NO filler words like "Ah", "Eeh", "Sawa cheki"
4. Be concise and professional
5. For direct questions, start with YES/NO then explain
''';
  }

  Future<String> fetchWebKnowledge(String query) async {
    await Future.delayed(const Duration(milliseconds: 100));
    // Your existing web knowledge logic here
    return '';
  }

  List<String> getSuggestedFollowUps(String query) {
    final context = detectLegalContext(query);
    final language = detectPrimaryLanguage(query);

    if (context == null) {
      return language == 'swahili'
          ? [
              "Niambie kuhusu haki za msingi",
              "Vipi kupata lawyer Nairobi?",
              "Mambo ya korti vipi?"
            ]
          : [
              "Tell me about basic rights",
              "How to find a lawyer in Nairobi?",
              "Court procedures?"
            ];
    }

    final suggestions = context.commonScenarios.take(3).toList();
    return language == 'swahili'
        ? suggestions.map((s) => "Je, $s?").toList()
        : suggestions.map((s) => "What about $s?").toList();
  }
}
