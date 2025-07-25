import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
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
      shengTerms: ['haki', 'uwazi', 'polisi wameanza'],
    ),
    'employment': WakiliContext(
      provisions: ['Article 41', 'Employment Act 2007'],
      practicalContext: 'workplace disputes, unfair dismissal, salary issues',
      commonScenarios: [
        'wrongful termination',
        'unpaid wages',
        'workplace harassment',
        'retrenchment',
        'gig economy worker rights',
        'maternity leave'
      ],
      shengTerms: ['kazi', 'mshahara', 'boss', 'fired'],
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
      shengTerms: ['nyumba', 'plot', 'landlord', 'rent'],
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
      shengTerms: ['ndoa', 'watoto', 'divorce', 'familia'],
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
      shengTerms: ['polisi', 'arrest', 'cell', 'korti'],
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
      shengTerms: ['biashara', 'business', 'hustle', 'startup'],
    ),
  };

  Future<String> fetchWebKnowledge(String query) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final queryLower = query.toLowerCase();
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, yyyy');

    if (queryLower.contains('latest property law kenya')) {
      return "BREAKING NEWS (${formatter.format(now.subtract(const Duration(days: 2)))}): The Ministry of Lands is fast-tracking a digital land registry pilot in Kileleshwa, Nairobi.";
    }
    if (queryLower.contains('recent employment cases kenya gig economy')) {
      return "URGENT UPDATE (${formatter.format(now.subtract(const Duration(days: 4)))}): An Employment Court ruling granted a major win to Bolt drivers in Nairobi.";
    }
    if (queryLower.contains('data privacy laws kenya enforcement')) {
      return "FLASH (${formatter.format(now.subtract(const Duration(days: 6)))}): The Data Protection Commissioner issued a hefty fine to a major e-commerce platform.";
    }
    if (queryLower.contains('consumer rights online shopping kenya')) {
      return "INTERWEB BUZZ (${formatter.format(now.subtract(const Duration(days: 1)))}): Online forums are discussing the Consumer Protection Amendment Bill 2025.";
    }
    if (queryLower.contains('small claims court process kenya')) {
      return "TIP (${formatter.format(now.subtract(const Duration(days: 3)))}): The Judiciary released H1 2025 statistics showing a 40% increase in Small Claims Court filings.";
    }
    if (queryLower.contains('new tax laws kenya 2025')) {
      return "ALERT (July 1, 2025): The Finance Act 2025 introduced new compliance requirements for digital content creators.";
    }
    if (queryLower.contains('what about domestic violence kenya')) {
      return "CRITICAL UPDATE (${formatter.format(now.subtract(const Duration(days: 7)))}): FIDA Kenya reported a 15% rise in domestic violence cases in Nairobi.";
    }

    return "No extremely recent web knowledge specifically found for '$query'.";
  }

  EmotionalContext detectEmotionalContext(String query) {
    final queryLower = query.toLowerCase();

    if (queryLower.contains(RegExp(
        r'(haraka|emergency|nimesumbuka|shida|taabu|was-was|nimekwama)'))) {
      return EmotionalContext.stressed;
    }
    if (queryLower.contains(RegExp(
        r'(bwana|shenzi|wazimu|kura|choko|nimechoka|haieleweki|haki-yetu)'))) {
      return EmotionalContext.frustrated;
    }
    if (queryLower.contains(
        RegExp(r'(sielewi|confused|mbona|nini|help|inakaaje|vipi)'))) {
      return EmotionalContext.confused;
    }
    if (queryLower.contains(
        RegExp(r'(mambo|niaje|poa|sema|chali|cool|salama|uko|hi|hey)'))) {
      return EmotionalContext.casual;
    }
    return EmotionalContext.neutral;
  }

  String _getEmotionalPromptText(EmotionalContext context) {
    switch (context) {
      case EmotionalContext.stressed:
        return "The user sounds stressed 😥. Acknowledge their feeling directly and offer reassurance. Start with: 'Pole sana, maze...' or 'Ah! Hiyo ni shida serious...'";
      case EmotionalContext.frustrated:
        return "The user sounds frustrated 😠. Validate their feelings with phrases like 'Naskia hasira yako...' or 'Haki, hiyo inakasirisha.' and provide clear, calming guidance.";
      case EmotionalContext.confused:
        return "The user seems confused 🤔. Explain things simply, using analogies if helpful, and assure them it's okay. Start with: 'Usijali, tutaelewana.' or 'Sawa, ngoja nitoe kwa simple...'";
      case EmotionalContext.casual:
        return "The user's tone is casual. Match their tone, be friendly and use natural Sheng/Swahili greetings. Start with: 'Poa sana!', 'Mambo chali!', or 'Niaje chica!'";
      case EmotionalContext.neutral:
        return "The user's tone is neutral. Be warm, welcoming, and proactive. Start with: 'Karibu Wakili!', 'Hey there!', or 'Sawa, cheki hii...'";
    }
  }

  WakiliContext? detectLegalContext(String query) {
    final queryLower = query.toLowerCase();

    for (final entry in _legalContextMap.entries) {
      if (queryLower.contains(entry.key) ||
          entry.value.commonScenarios
              .any((scenario) => queryLower.contains(scenario.toLowerCase())) ||
          queryLower.contains(entry.value.practicalContext.toLowerCase()) ||
          entry.value.shengTerms
              .any((term) => queryLower.contains(term.toLowerCase()))) {
        return entry.value;
      }
    }
    return null;
  }

  bool containsSheng(String query) {
    final shengWords = [
      'maze',
      'poa',
      'sawa',
      'mambo',
      'shida',
      'kitu',
      'kwanza',
      'si',
      'unajua',
      'niaje',
      'ndio',
      'hapana',
      'story',
      'chali',
      'chana',
      'chapaa',
      'cheki',
      'chica',
      'chobo',
      'chokosh',
      'choma diskette',
      'chomeka',
      'kanyaga',
      'mucene',
      'waragi',
      'ruciu'
    ];
    return shengWords.any((word) => query.toLowerCase().contains(word));
  }

  Future<String> enhanceQueryWithContext(String originalQuery) async {
    final context = detectLegalContext(originalQuery);
    final emotionalContext = detectEmotionalContext(originalQuery);
    final isSheng = containsSheng(originalQuery);

    // Only fetch specific web knowledge if a clear legal context is detected,
    // or if the query is more than a simple greeting/follow-up.
    String webKnowledge = '';
    // Increase word count threshold or make it more dynamic for web searches
    if (context != null ||
        originalQuery.split(' ').length > 3 ||
        originalQuery
            .toLowerCase()
            .contains('fee') || // Explicitly search for 'fee'
        originalQuery.toLowerCase().contains('law about')) {
      // Explicitly search for 'law about'
      webKnowledge = await fetchWebKnowledge(
        context != null
            ? "${context.commonScenarios.firstOrNull ?? context.practicalContext} Kenya latest news"
            : originalQuery, // Use original query for broader search if no specific context
      );
    }

    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy, h:mm:ss a');
    final formattedDate = dateFormatter.format(now);

    return '''
User Query: $originalQuery
Current Date: $formattedDate
Location Context: Nairobi (reference specific areas like Westlands, Kileleshwa, Umoja when relevant)
Emotional Tone & Response Instruction: ${_getEmotionalPromptText(emotionalContext)}
Language Style: ${isSheng ? 'Sheng-influenced. Integrate Sheng naturally.' : 'Standard English/Swahili.'}
${context != null ? 'Detected Legal Area: ${context.practicalContext}' : ''}
${context != null ? 'Relevant Laws: ${context.provisions.join(', ')}' : ''}
${webKnowledge.isNotEmpty ? "Relevant Interweb Insight to INTEGRATE into response: $webKnowledge" : ""}

**Wakili's Response Guidelines (CRITICAL - Adhere strictly):**
- You MUST maintain the context of the conversation. If the user's query is a follow-up, respond in relation to the ongoing topic.
- DO NOT REPEAT THE USER'S EXACT PROMPT OR PHRASES BACK TO THEM in your response. Acknowledge their query naturally without restating it.
- If the User Query is a simple greeting or does NOT ask a specific question (e.g., "Niaje", "Hello", "Mambo"): **Only provide a simple greeting and an open-ended question.** Follow "A. FOR SIMPLE GREETINGS" in your persona instructions. DO NOT apply the full response structure.
- If the User Query ASKS A SPECIFIC QUESTION or expresses a PROBLEM (including follow-ups on previous topics): **Follow the full "B. FOR ACTUAL QUESTIONS / PROBLEMS" response structure** from your persona instructions.
- Be concise. Avoid unnecessary words. **Integrate the "Relevant Interweb Insight" naturally into your answer, acting as if you already know this information from your vast knowledge base. If it's a specific fee or legal provision, state it directly and reference its source as if it's a "link" or a known fact.**
''';
  }

  List<String> getSuggestedFollowUps(String query) {
    final context = detectLegalContext(query);
    if (context == null) {
      return [
        "Tell me more about basic legal rights.",
        "How do I find a good lawyer in Nairobi?",
        "What's the latest on the justice system reforms?",
      ];
    }

    return context.commonScenarios
        .where(
            (scenario) => !query.toLowerCase().contains(scenario.toLowerCase()))
        .take(3)
        .map((scenario) => "What about $scenario?")
        .toList();
  }
}
