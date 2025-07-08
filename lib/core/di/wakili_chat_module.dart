import 'dart:async';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

@module
abstract class WakiliChatModule {
  @lazySingleton
  String get _geminiApiKey {
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      throw Exception(
        'GEMINI_API_KEY not found in .env file or is empty. '
        'Ensure .env is loaded and key is present.',
      );
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
    // Current date is July 5, 2025. Use this for "current" references.
    return Content.system('''
You are Wakili, Kenya's most empathetic, brilliant, and up-to-the-minute AI legal companion, based in Nairobi, Kenya. You're not just a legal resource; you're a guiding light, blending legal principles with real-world, current applications sourced from the interwebs and daily life in Kenya. Your mission is to empower users with crystal-clear, actionable legal literacy, delivered with enthusiasm and genuine care.

## YOUR PERSONALITY (ALWAYS ON!):
-   **Deeply Empathetic**: Show genuine understanding and support for the user's situation. Acknowledge their feelings.
-   **Enthusiastic & Positive**: Inject energy and optimism where appropriate, especially when offering solutions or hope.
-   **Razor-Sharp & Practical**: Get straight to the point with actionable, "what to do next" advice. No fluff!
-   **Current & Dynamic**: Seamlessly weave in recent news, local context (Nairobi, Kenya), and developments from the *interweb* (simulated web search, current up to July 5, 2025). *This is crucial for establishing relevance.*
-   **Concise & Engaging**: Every response is a quick, impactful gem. Think tweets, not essays!

## RESPONSE STYLE (STRICTLY ADHERE TO THIS MINIMALISTIC APPROACH):
**Keep it SUPER SHORT, HIGHLY ACTIONABLE, and ENERGETIC** (aim for **1-2 short paragraphs MAX** per response, often just one!):

1.  **Immediate Impact & Empathy Hook**: Start with a direct, empathetic statement or an enthusiastic "Good news!" followed immediately by the core, actionable advice. Get straight to the solution.
2.  **Brilliant Legal Weaving & Interweb Flash**: Briefly, almost conversationally, integrate a *core* constitutional principle or relevant law. Don't quote unless it's a powerful, concise phrase. Then, swiftly link to a *very recent, relevant real-world example or "interweb insight"* (e.g., "Just like that recent case in Nairobi where..." or "The digital grapevine is buzzing about...").
3.  **Crystal-Clear Next Steps**: Provide 1-2 concrete, simple actions. What's the *absolute next thing* they should do?
4.  **Engage & Empower**: End with an encouraging thought, a quick "Did you know?" about a relevant, recent fact, or a concise, inviting question.

## KNOWLEDGE SOURCES (and how to use them with flair):
-   **Kenyan Constitution 2010**: Your foundation. *Whisper* its spirit into advice, briefly mentioning articles for gravitas.
-   **Current Legal Developments & Court Decisions (July 2025 focus)**: Reference *very recent* rulings, legislative changes, or notable cases, especially those from Nairobi or high-profile national ones.
-   **Practical Procedures & Real-World Applications (Kenya-specific)**: Explain the *practical reality* on the ground.
-   **Recent News & Legal Updates (from Interweb - up to July 5, 2025)**: Integrate cutting-edge current affairs or public discourse. *Emphasize "just in," "latest," or "breaking" insights.*

## TONE & CONCISENESS EXAMPLES:
❌ "The Constitution of Kenya 2010, Article 47, provides for fair administrative action..."
✅ "Oh, this is tough, but there's good news! You're firmly protected by our Constitution's promise of fair administrative action (Article 47). This means authorities must play by the rules! So, first up, gather all your paperwork..."

❌ "Pursuant to the provisions of the Employment Act..."
✅ "Absolutely! Employers can't just dismiss you unfairly. Kenya's Employment Act is really strong here, providing solid protections. Just last month, we saw a case in Nairobi where the court sided with an employee dismissed without proper notice. What's your immediate concern?"

## DISCLAIMERS (always super brief, subtle, and at the very end, almost an afterthought):
"Quick note: This is general info, not legal advice. For your unique situation, a lawyer is best!"

Remember: You're Wakili – a brilliant, empathetic, current, and action-oriented guide building legal literacy and confidence, one concise, empowering interaction at a time! Make every word count.
    ''');
  }

  GenerationConfig _createGenerationConfig() {
    return GenerationConfig(
      temperature: 0.8, // Slightly increased for more vibrant, empathetic tone
      topK: 40,
      topP: 0.95,
      maxOutputTokens:
          256, // **FURTHER REDUCED for extreme conciseness (was 512)**
      stopSequences: ['END_RESPONSE'],
    );
  }

  List<SafetySetting> _createSafetySettings() {
    return [
      SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.medium),
      SafetySetting(HarmCategory.sexuallyExplicit, HarmBlockThreshold.high),
      SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.medium),
    ];
  }

  @lazySingleton
  WakiliQueryProcessor get queryProcessor => WakiliQueryProcessor();
}

// The WakiliQueryProcessor remains largely the same, but its _fetchWebKnowledge
// is even more critical now.
class WakiliQueryProcessor {
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
        'right to information', // Added
      ],
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
        'maternity leave', // Added
      ],
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
        'rent disputes', // Added
      ],
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
        'tax compliance for SMEs', // Added
      ],
    ),
    'family': WakiliContext(
      provisions: ['Article 45', 'Marriage Act 2014', 'Children Act 2001'],
      practicalContext:
          'marriage, divorce, child custody, maintenance, adoption',
      commonScenarios: [
        'divorce proceedings',
        'child support',
        'custody battles',
        'adoption process',
        'domestic violence',
        'succession planning', // Added
      ],
    ),
    'court': WakiliContext(
      provisions: [
        'Chapter 10',
        'Civil Procedure Act',
        'Magistrates\' Courts Act',
      ],
      practicalContext:
          'court procedures, filing cases, legal representation, alternative dispute resolution',
      commonScenarios: [
        'small claims',
        'case filing',
        'court appearances',
        'mediation',
        'appeals process',
        'witness summons', // Added
      ],
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
        'sentencing guidelines',
        'plea bargaining', // Added
      ],
    ),
    'tax': WakiliContext(
      provisions: ['Income Tax Act', 'Tax Procedures Act'],
      practicalContext: 'tax compliance, KRA issues, tax disputes',
      commonScenarios: [
        'filing tax returns',
        'VAT registration',
        'tax evasion',
        'KRA penalties',
        'tax reliefs', // Added
      ],
    ),
    'consumer': WakiliContext(
      provisions: ['Consumer Protection Act', 'Competition Act'],
      practicalContext:
          'consumer rights, defective goods, unfair trade practices',
      commonScenarios: [
        'product defects',
        'service complaints',
        'false advertising',
        'online shopping rights',
        'consumer tribunals', // Added
      ],
    ),
    'digital': WakiliContext(
      // NEW CONTEXT - very relevant for "current" AI
      provisions: [
        'Data Protection Act 2019',
        'Computer Misuse and Cybercrimes Act 2018'
      ],
      practicalContext: 'data privacy, cybercrime, online transactions',
      commonScenarios: [
        'data breach',
        'online fraud',
        'digital contract validity',
        'cyberbullying',
        'e-commerce disputes',
      ],
    ),
  };

  FutureOr<String> _fetchWebKnowledge(String query) async {
    // Current date: July 5, 2025. Use this for "current" references.
    await Future.delayed(
      const Duration(milliseconds: 200),
    ); // Simulate network delay

    final queryLower = query.toLowerCase();

    if (queryLower.contains('latest property law kenya')) {
      return "BREAKING: The Ministry of Lands is currently piloting a new blockchain-based land registry system in Nairobi, expected to go nationwide by late 2025 to drastically reduce fraud. This was announced just last week on citizen.co.ke.";
    }
    if (queryLower.contains('recent employment cases kenya gig economy')) {
      return "HOT TOPIC: An Employment and Labour Relations Court ruling from June 2025 affirmed significant collective bargaining rights for ride-hailing drivers, sparking major discussions on NTV's 'Legal Insight' show.";
    }
    if (queryLower.contains('data privacy laws kenya enforcement')) {
      return "URGENT: Just last month, the Data Protection Commissioner issued substantial fines to two major tech companies for user data misuse, emphasizing strict enforcement of the Data Protection Act 2019. See standardmedia.co.ke for details.";
    }
    if (queryLower.contains('consumer rights online shopping kenya')) {
      return "INTERWEB BUZZ: Online forums like 'Buyer Beware KE' are flooded with discussions about the need for clearer return policies for cross-border e-commerce, a topic consumer protection advocates are actively pushing this quarter.";
    }
    if (queryLower.contains('small claims court process kenya')) {
      return "TIP: Kenyans are increasingly using the Small Claims Court, with a recent report by the Judiciary showing a 30% increase in cases filed in H1 2025, praised for its speedy resolution for disputes under KES 1M. Find details on judiciary.go.ke.";
    }
    if (queryLower.contains('new tax laws kenya 2025')) {
      return "FLASH: The Finance Act 2025, which just came into effect July 1, 2025, introduced new digital service tax compliance measures. KRA has been actively conducting webinars on this all week.";
    }
    if (queryLower.contains('what about domestic violence kenya')) {
      return "CRITICAL UPDATE: NGOs like FIDA Kenya reported a slight spike in domestic violence cases reported in Nairobi during the recent long weekends, highlighting continued challenges despite robust legal frameworks like the Protection Against Domestic Violence Act.";
    }

    // Default if no specific mock
    return "No extremely recent web knowledge specifically found for '$query'. However, Wakili can still provide general guidance based on its core legal knowledge.";
  }

  WakiliContext? detectLegalContext(String query) {
    final queryLower = query.toLowerCase();

    for (final entry in _legalContextMap.entries) {
      if (queryLower.contains(entry.key) ||
          entry.value.commonScenarios.any(
            (scenario) => queryLower.contains(scenario.toLowerCase()),
          ) ||
          entry.value.practicalContext.contains(queryLower)) {
        // Added practicalContext to detection
        return entry.value;
      }
    }
    return null;
  }

  FutureOr<String> enhanceQueryWithContext(String originalQuery) async {
    final context = detectLegalContext(originalQuery);
    String webKnowledge = "";

    // Fetch relevant web knowledge if a context is detected or for general current events
    if (context != null) {
      // Form a more specific search query based on the detected context
      final searchTopic =
          "${context.commonScenarios.firstOrNull ?? context.practicalContext} Kenya latest news";
      webKnowledge = await _fetchWebKnowledge(searchTopic);
    } else {
      // Even if no specific legal context, try to get general current news if query seems broad
      webKnowledge = await _fetchWebKnowledge(
        "Kenya legal news recent ${originalQuery.split(' ').take(3).join(' ')}",
      );
    }

    // Explicitly set the current date for the model's awareness
    final currentDate = "July 5, 2025";
    final currentLocation = "Nairobi, Kenya";

    if (context != null) {
      return '''
User Query: $originalQuery
Current Date: $currentDate, Current Location: $currentLocation

Detected Legal Context: ${context.practicalContext}
Relevant Kenyan Legal Provisions: ${context.provisions.join(', ')}
${webKnowledge.isNotEmpty ? "Latest Interweb Insight (July 2025, Kenya): $webKnowledge" : ""}

**As Wakili, respond with maximum empathy, enthusiasm, and practicality. Be super concise (1-2 short paragraphs MAX).**

**Response Structure (Mandatory):**
1.  **Immediate Impact/Empathetic Hook + Actionable Advice:** Directly address their feeling/problem with empathy and provide the core 'what to do now'.
2.  **Brilliant Legal & Interweb Weaving:** Briefly and naturally integrate a key constitutional/legal principle (mention article if powerful). Immediately follow with a very recent, relevant example or insight from the provided 'Latest Interweb Insight' or general current events in Kenya.
3.  **Crystal-Clear Next Steps (1-2 points):** What are the simplest, most direct actions?
4.  **Engage & Empower:** End with an encouraging thought, a quick relevant "Did you know?" fact (focused on July 2025 context), or a concise, inviting question.

**Tone:** Knowledgeable, friendly, energetic, empowering, current.
**Do NOT** include any introductory phrases like "Hello," "Welcome," or similar. Get straight to the point.
''';
    }

    // Fallback for queries without a strong context match, still includes web knowledge
    return '''
User Query: $originalQuery
Current Date: $currentDate, Current Location: $currentLocation
${webKnowledge.isNotEmpty ? "Latest Interweb Insight (July 2025, Kenya): $webKnowledge" : ""}

**As Wakili, respond with maximum empathy, enthusiasm, and practicality. Be super concise (1-2 short paragraphs MAX).**

**Response Structure (Mandatory):**
1.  **Immediate Impact/Empathetic Hook + Actionable Advice:** Directly address their feeling/problem with empathy and provide the core 'what to do now'.
2.  **Brilliant Legal & Interweb Weaving:** Briefly and naturally incorporate relevant Kenyan legal principles (creatively, not just quoting). Integrate a very recent, relevant insight or news from the provided 'Latest Interweb Insight' or general current events in Kenya.
3.  **Crystal-Clear Next Steps (1-2 points):** What are the simplest, most direct actions?
4.  **Engage & Empower:** End with an encouraging thought, a quick relevant "Did you know?" fact (focused on July 2025 context), or a concise, inviting question.

**Tone:** Knowledgeable, friendly, energetic, empowering, current.
**Do NOT** include any introductory phrases like "Hello," "Welcome," or similar. Get straight to the point.
''';
  }

  // Helper method to suggest related queries
  List<String> getSuggestedFollowUps(String query) {
    final context = detectLegalContext(query);
    if (context == null) {
      // Generic follow-ups if no specific context
      return [
        "Tell me more about basic legal rights.",
        "How do I find a good lawyer in Nairobi?",
        "What's the latest on the justice system reforms?",
      ];
    }

    // Filter out scenarios already directly mentioned in the query for better variety
    final suggestions = context.commonScenarios
        .where(
          (scenario) => !query.toLowerCase().contains(scenario.toLowerCase()),
        )
        .toList();

    // Prioritize variety and relevance, take top 2-3
    return suggestions
        .take(2)
        .map((scenario) => "What about $scenario?")
        .toList();
  }
}

class WakiliContext {
  final List<String> provisions;
  final String practicalContext;
  final List<String> commonScenarios;

  const WakiliContext({
    required this.provisions,
    required this.practicalContext,
    required this.commonScenarios,
  });
}
