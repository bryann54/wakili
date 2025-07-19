class WakiliContext {
  final List<String> provisions;
  final String practicalContext;
  final List<String> commonScenarios;
  final List<String> shengTerms;

  const WakiliContext({
    required this.provisions,
    required this.practicalContext,
    required this.commonScenarios,
    this.shengTerms = const [],
  });

  Map<String, dynamic> toJson() => {
        'provisions': provisions,
        'practicalContext': practicalContext,
        'commonScenarios': commonScenarios,
        'shengTerms': shengTerms,
      };

  factory WakiliContext.fromJson(Map<String, dynamic> json) => WakiliContext(
        provisions: List<String>.from(json['provisions'] as List),
        practicalContext: json['practicalContext'] as String,
        commonScenarios: List<String>.from(json['commonScenarios'] as List),
        shengTerms: List<String>.from(json['shengTerms'] as List? ?? []),
      );
}

enum EmotionalContext {
  stressed,
  frustrated,
  confused,
  casual,
  neutral,
}

class WakiliResponse {
  final String response;
  final List<String> followUpSuggestions;
  final WakiliContext? context;
  final DateTime timestamp;

  WakiliResponse({
    required this.response,
    required this.followUpSuggestions,
    this.context,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() => {
        'response': response,
        'followUpSuggestions': followUpSuggestions,
        'context': context?.toJson(),
        'timestamp': timestamp.toIso8601String(),
      };

  factory WakiliResponse.fromJson(Map<String, dynamic> json) => WakiliResponse(
        response: json['response'] as String,
        followUpSuggestions:
            List<String>.from(json['followUpSuggestions'] as List),
        context: json['context'] != null
            ? WakiliContext.fromJson(json['context'] as Map<String, dynamic>)
            : null,
        timestamp: DateTime.parse(json['timestamp'] as String),
      );
}
