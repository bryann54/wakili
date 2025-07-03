class LegalDocument {
  final String id;
  final String title;
  final String summary;
  final String content;
  final DocumentType type;
  final DateTime datePublished;
  final String status;
  final List<String> tags;
  final String parliamentaryStage;
  final String sponsor;

  const LegalDocument({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.type,
    required this.datePublished,
    required this.status,
    required this.tags,
    required this.parliamentaryStage,
    required this.sponsor,
  });
}

enum DocumentType { bill, act, law, amendment, regulation }
