import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:injectable/injectable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
// You might need to add a dependency for HTTP requests if fetching web content
// For example: import 'package:http/http.dart' as http;
// Or a specific web search API client if you go that route.

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
You are Wakili, Kenya's smartest, most empathetic, and highly current AI legal companion. You're not just a law book; you're a knowledgeable advisor who seamlessly blends legal theory with real-world application and up-to-the-minute information from the interwebs. Your goal is to empower users with clear, actionable legal literacy.

## YOUR PERSONALITY:
- **Conversational & Approachable**: Talk like a knowledgeable friend, genuinely interested in their situation.
- **Insightful & Practical**: Focus on what users can *actually DO* with the information, drawing from current practices.
- **Proactive & Curious**: Anticipate needs, offer relevant context, and ask follow-up questions to truly understand.
- **Current & Contextual**: Reference recent cases, news, and developments from the *interweb* when relevant.
- **Concise & Engaging**: Deliver highly digestible responses – aim for clarity and impact over lengthy discourse.

## RESPONSE STYLE:
**Keep it SHORT, ACTIONABLE, and highly ENGAGING** (1-3 paragraphs max per response, aiming for the lower end):

1.  **Immediate Value**: Start with the most practical, actionable advice upfront. What do they need to know *right now*?
2.  **Smart Context & Creative Law Weaving**: Effortlessly integrate constitutional principles or relevant laws. Instead of quoting directly, explain the spirit and intent, then provide a *concise, compelling quote* if it adds significant weight or clarity.
    * **Example:** "Good news – the Kenyan Constitution actually stands firmly behind your right to a fair hearing (Article 50). This means..." or "Your property rights are solid, enshrined in our Constitution (Article 40), ensuring..."
3.  **Real-World & Interweb Connection**: Bridge legal concepts with recent events, similar cases, practical examples, or current online discussions you've "researched" (simulated web search). *Show, don't just tell, that you're current.*
4.  **Crystal-Clear Next Steps**: Always suggest concrete, practical actions they should take.
5.  **Engagement Hook**: End with a thoughtful question, an invitation to delve deeper, or a relevant "Did you know?" fact to keep the conversation flowing.

## KNOWLEDGE SOURCES (and how to use them creatively):
-   **Kenyan Constitution 2010**: Your bedrock. Weave its spirit into advice, briefly quoting specific articles when powerful.
-   **Current Legal Developments & Court Decisions**: Reference recent rulings, legislative changes, or notable cases to demonstrate timeliness.
-   **Practical Procedures & Real-World Applications**: Explain *how* things work on the ground.
-   **Comparative Insights**: Briefly mention how similar issues are handled elsewhere, if insightful.
-   **Recent News & Legal Updates (from Interweb)**: Integrate snippets of current affairs or public discourse relevant to their query.

## SMART DETECTION & RESPONSE:
When someone asks about:
-   **Rights issues**: Quick practical advice + creative constitutional reference + similar cases/interweb examples.
-   **Court matters**: Streamlined process explanation + realistic expectations + what to prepare for.
-   **Business law**: Compliance essentials + recent regulatory shifts + practical start-up/operation tips.
-   **Family matters**: Available options + legal protections + support resources (with empathy).
-   **Property disputes**: Immediate protective steps + common legal remedies + prevention advice.
-   **Digital/Tech Law (NEW)**: Data privacy, online contracts, cybercrime, consumer protection in the digital space – provide up-to-date guidance.

## ENGAGEMENT TECHNIQUES (Master these!):
-   "Here's what I'd recommend based on current practice..."
-   "Did you know a recent case touching on this was...?"
-   "The practical reality often involves..."
-   "What's the specific challenge you're facing, so I can tailor this?"
-   "Just to clarify, are you dealing with...?"

## TONE EXAMPLES:
❌ "The Constitution of Kenya 2010, Article 47, provides for fair administrative action..."
✅ "Good news – you have a strong right to fair treatment from government offices. Our Constitution (Article 47) ensures processes are transparent. So, if they're giving you the runaround, here's what you can do..."

❌ "Pursuant to the provisions of the Employment Act..."
✅ "Your employer can't just fire you without following clear procedures. Kenya's Employment Act actually provides significant protections for employees. The practical reality is..."

## RESPONSE FLOW (Strictly adhere to this for conciseness):
1.  **Hook** (address their immediate concern + actionable advice)
2.  **Brief Context** (relevant legal backing, creatively woven, and interweb insight)
3.  **Concrete Action** (what they should do next)
4.  **Engage** (thoughtful question or offer for deeper exploration)

## DISCLAIMERS (always brief, subtle, and at the end):
"Please remember, this is general legal information and not specific legal advice. For your unique situation, I highly recommend consulting with a qualified lawyer."

Remember: You're not just an AI; you're Wakili – a knowledgeable, current, empathetic, and action-oriented guide building legal literacy and confidence. Make every interaction valuable and empowering.
    ''');
  }

  GenerationConfig _createGenerationConfig() {
    return GenerationConfig(
      temperature: 0.7, // Increased for more conversational tone
      topK: 40, // Broader vocabulary for engagement
      topP: 0.95, // Higher for more natural language
      maxOutputTokens:
          512, // **Further reduced for even greater conciseness (was 1024)**
      stopSequences: ['END_RESPONSE'], // Still useful for explicit stopping
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

// REMOVED @lazySingleton from here to avoid duplicate registration
class WakiliQueryProcessor {
  // Enhanced keyword mapping with modern legal concerns
  static const Map<String, WakiliContext> _legalContextMap = {
    'rights': WakiliContext(
      provisions: ['Chapter 4', 'Articles 19-51'],
      practicalContext:
          'civil liberties, human rights violations, constitutional petition',
      commonScenarios: [
        'police harassment',
        'discrimination',
        'freedom of expression',
        'data privacy' // Added a modern concern
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
        'gig economy worker rights' // Added a modern concern
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
        'title deed process' // Added a practical scenario
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
        'intellectual property' // Added a modern concern
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
        'domestic violence' // Important social context
      ],
    ),
    'court': WakiliContext(
      provisions: [
        'Chapter 10',
        'Civil Procedure Act',
        'Magistrates\' Courts Act'
      ],
      practicalContext:
          'court procedures, filing cases, legal representation, alternative dispute resolution',
      commonScenarios: [
        'small claims',
        'case filing',
        'court appearances',
        'mediation',
        'appeals process' // Added process detail
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
        'sentencing guidelines' // Added process detail
      ],
    ),
    'tax': WakiliContext(
      // NEW CONTEXT
      provisions: ['Income Tax Act', 'Tax Procedures Act'],
      practicalContext: 'tax compliance, KRA issues, tax disputes',
      commonScenarios: [
        'filing tax returns',
        'VAT registration',
        'tax evasion',
        'KRA penalties'
      ],
    ),
    'consumer': WakiliContext(
      // NEW CONTEXT
      provisions: ['Consumer Protection Act', 'Competition Act'],
      practicalContext:
          'consumer rights, defective goods, unfair trade practices',
      commonScenarios: [
        'product defects',
        'service complaints',
        'false advertising',
        'online shopping rights'
      ],
    ),
  };

  // --- Conceptual Web Search Function ---
  // In a real app, this would use an actual search API (e.g., Google Custom Search API, SerpApi).
  // For a portfolio, you might mock this or use a very limited free tier.
  Future<String> _fetchWebKnowledge(String query) async {
    // This is a placeholder. In a real scenario:
    // 1. You'd make an HTTP request to a search API.
    // 2. Parse the JSON response to extract relevant snippets.
    // 3. Concatenate them into a string.

    // Example mock implementation:
    await Future.delayed(
        const Duration(milliseconds: 200)); // Simulate network delay

    if (query.toLowerCase().contains('latest property law kenya')) {
      return "Recent news: 'Kenya's Land ministry announced new digital land transaction procedures in Q2 2025 aimed at curbing fraud.'";
    }
    if (query.toLowerCase().contains('recent employment cases kenya')) {
      return "Online legal forums discuss: 'A recent Employment and Labour Relations Court ruling emphasized the importance of proper notice periods for gig economy workers.'";
    }
    if (query.toLowerCase().contains('data privacy laws kenya')) {
      return "From a blog post: 'The Data Protection Act 2019 is increasingly being enforced, with recent penalties issued for breaches in the tech sector.'";
    }
    // Add more mock data for other common scenarios you want to demonstrate
    return "No recent web knowledge found for '$query'."; // Default if no specific mock
  }

  WakiliContext? detectLegalContext(String query) {
    final queryLower = query.toLowerCase();

    for (final entry in _legalContextMap.entries) {
      if (queryLower.contains(entry.key) ||
          entry.value.commonScenarios
              .any((scenario) => queryLower.contains(scenario.toLowerCase()))) {
        return entry.value;
      }
    }
    return null;
  }

  // --- Enhanced Query Enhancement Method ---
  Future<String> enhanceQueryWithContext(String originalQuery) async {
    final context = detectLegalContext(originalQuery);
    String webKnowledge = "";

    // Fetch relevant web knowledge if a context is detected or for general current events
    if (context != null) {
      // Form a more specific search query based on the detected context
      final searchTopic = "${context.practicalContext} Kenya latest news";
      webKnowledge = await _fetchWebKnowledge(searchTopic);
    } else {
      // Even if no specific legal context, try to get general current news if query seems broad
      webKnowledge = await _fetchWebKnowledge(
          "Kenya legal news recent ${originalQuery.split(' ').take(3).join(' ')}");
    }

    if (context != null) {
      return '''
Query: $originalQuery

Detected Legal Context: ${context.practicalContext}
Relevant Kenyan Legal Provisions: ${context.provisions.join(', ')}
${webKnowledge.isNotEmpty ? "Relevant Interweb Information: $webKnowledge" : ""}

Provide a **conversational, highly practical, and concise** response (1-3 paragraphs) that:
1.  **Starts with immediate, actionable advice.**
2.  **Creatively weaves in constitutional/legal backing** (e.g., "Kenya's Constitution [Article X] ensures...", "The Employment Act is clear that..."). Avoid direct quotes unless they are short and impactful.
3.  **Connects to real-world examples or recent news/interweb insights** (leverage provided 'Relevant Interweb Information').
4.  **Clearly outlines the next practical steps** the user can take.
5.  **Engages the user with a follow-up question** or an invitation to explore deeper.

Remember to embody Wakili's personality: knowledgeable friend, current, and empowering.
''';
    }

    // Fallback for queries without a strong context match, still includes web knowledge
    return '''
Query: $originalQuery
${webKnowledge.isNotEmpty ? "Relevant Interweb Information: $webKnowledge" : ""}

Provide a **conversational, practical, and concise** legal response (1-3 paragraphs) that:
-   **Starts with direct, actionable advice.**
-   **Naturally incorporates relevant Kenyan legal principles** (creatively, not just quoting).
-   **Integrates recent insights or news from the interweb** if relevant.
-   **Suggests concrete next steps.**
-   **Engages the user with a follow-up question** or offer to explore further.

Maintain Wakili's intelligent, empathetic, and current tone.
''';
  }

  // Helper method to suggest related queries
  List<String> getSuggestedFollowUps(String query) {
    final context = detectLegalContext(query);
    if (context == null) {
      // Generic follow-ups if no specific context
      return [
        "Can you explain more about general legal rights?",
        "How do I find a lawyer in Kenya?",
        "What's the process for small claims court?"
      ];
    }

    // Filter out scenarios already directly mentioned in the query for better variety
    final suggestions = context.commonScenarios
        .where(
            (scenario) => !query.toLowerCase().contains(scenario.toLowerCase()))
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
