// lib/core/chat/wakili_chat_core.dart
import 'dart:async';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'package:wakili/core/chat/wakili_chat_models.dart';

class ConversationManager {
  ConversationManager();
  final Map<String, List<Content>> _conversations = {};

  /// Keeps only the last 20 messages
  void addMessage(String sessionId, Content message) {
    _conversations[sessionId] ??= [];
    _conversations[sessionId]!.add(message);

    // Maintain a reasonable history size for the model
    const maxHistoryLength = 20;
    if (_conversations[sessionId]!.length > maxHistoryLength) {
      _conversations[sessionId]!
          .removeRange(0, _conversations[sessionId]!.length - maxHistoryLength);
    }
  }

  /// Retrieves the current conversation history for a session.
  List<Content> getConversationHistory(String sessionId) {
    return _conversations[sessionId] ?? [];
  }

  /// Clears the conversation history for a specific session.
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
        'right to information',
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
        'maternity leave',
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
        'rent disputes',
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
        'succession planning',
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
        'plea bargaining',
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
        'intellectual property',
      ],
      shengTerms: ['biashara', 'business', 'hustle', 'startup'],
    ),
  };

  /// Simulates fetching current web knowledge. In a real app, this would query a search API.
  Future<String> fetchWebKnowledge(String query) async {
    // Simulate network delay for realism
    await Future.delayed(const Duration(milliseconds: 200));

    final queryLower = query.toLowerCase();
    final now = DateTime.now();
    final formatter = DateFormat('MMMM d, yyyy');

    // Updated and more specific mock web knowledge
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

  /// Detects the emotional context of a user's query.
  EmotionalContext detectEmotionalContext(String query) {
    final queryLower = query.toLowerCase();

    if (queryLower.contains(
        RegExp(r'(urgent|help|desperate|stressed|worried|scared|emergency)'))) {
      return EmotionalContext.stressed;
    }
    if (queryLower
        .contains(RegExp(r'(frustrated|angry|mad|unfair|ridiculous|stupid)'))) {
      return EmotionalContext.frustrated;
    }
    if (queryLower.contains(
        RegExp(r'(confused|not understanding|unclear|lost|complicated)'))) {
      return EmotionalContext.confused;
    }
    if (queryLower.contains(RegExp(r'(hey|hi|mambo|poa|sawa|niaje)'))) {
      return EmotionalContext.casual;
    }
    return EmotionalContext.neutral;
  }

  /// Detects the relevant legal context of a query using keywords and common scenarios.
  WakiliContext? detectLegalContext(String query) {
    final queryLower = query.toLowerCase();

    for (final entry in _legalContextMap.entries) {
      if (queryLower.contains(entry.key) ||
          entry.value.commonScenarios.any(
            (scenario) => queryLower.contains(scenario.toLowerCase()),
          ) ||
          queryLower.contains(entry.value.practicalContext.toLowerCase()) ||
          entry.value.shengTerms.any(
            (term) => queryLower.contains(term.toLowerCase()),
          )) {
        return entry.value;
      }
    }
    return null;
  }

  /// Checks if the query contains common Sheng words.
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
      'story'
    ];
    return shengWords.any((word) => query.toLowerCase().contains(word));
  }

  /// Generates the emotional prompt text based on detected emotional context.
  String _getEmotionalPromptText(EmotionalContext context) {
    switch (context) {
      case EmotionalContext.stressed:
        return "The user seems stressed. Acknowledge their feeling and offer reassurance.";
      case EmotionalContext.frustrated:
        return "The user sounds frustrated. Validate their feelings and provide clear guidance.";
      case EmotionalContext.confused:
        return "The user seems confused. Explain things simply and assure them.";
      case EmotionalContext.casual:
        return "The user's tone is casual. Match their tone and be friendly.";
      case EmotionalContext.neutral:
        return "The user's tone is neutral. Be warm and proactive.";
    }
  }

  /// Enhances the original query with detected context, emotional tone, and web knowledge.
  Future<String> enhanceQueryWithContext(String originalQuery) async {
    final context = detectLegalContext(originalQuery);
    final emotionalContext = detectEmotionalContext(originalQuery);
    final isSheng = containsSheng(originalQuery);

    String webKnowledge = await fetchWebKnowledge(
      context != null
          ? "${context.commonScenarios.firstOrNull ?? context.practicalContext} Kenya latest news"
          : "Kenya legal news recent ${originalQuery.split(' ').take(3).join(' ')}",
    );

    final now = DateTime.now();
    final dateFormatter = DateFormat('EEEE, MMMM d, yyyy, h:mm:ss a');
    final formattedDate = dateFormatter.format(now);

    return '''
User Query: $originalQuery
Current Date: $formattedDate
Current Location: Nairobi, Kenya
Emotional Context: ${emotionalContext.name}
Language Style: ${isSheng ? 'Sheng-influenced' : 'Standard'}
${context != null ? 'Detected Legal Context: ${context.practicalContext}' : ''}
${context != null ? 'Relevant Kenyan Legal Provisions: ${context.provisions.join(', ')}' : ''}
${webKnowledge.isNotEmpty ? "Latest Interweb Insight: $webKnowledge" : ""}

**As Wakili, respond naturally and empathetically:**
1. Emotional Acknowledgment: ${_getEmotionalPromptText(emotionalContext)}
2. Direct Answer & Legal Insight: Provide clear, practical legal guidance.
3. Practical Next Step: What's the single most important immediate action?
4. Conversational Bridge: Ask a concise follow-up question.
''';
  }

  /// Generates context-aware follow-up suggestions for the user.
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
