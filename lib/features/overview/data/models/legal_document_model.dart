import 'package:wakili/features/overview/domain/entities/legal_document.dart';

class LegalDocumentModel extends LegalDocument {
  const LegalDocumentModel({
    required super.id,
    required super.title,
    required super.summary,
    required super.content,
    required super.type,
    required super.datePublished,
    required super.status,
    required super.tags,
    required super.parliamentaryStage,
    required super.sponsor,
  });

  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      type: _parseDocumentType(json['type']),
      datePublished: DateTime.parse(
          json['datePublished'] ?? DateTime.now().toIso8601String()),
      status: json['status'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      parliamentaryStage: json['parliamentaryStage'] ?? '',
      sponsor: json['sponsor'] ?? '',
    );
  }

  static DocumentType _parseDocumentType(String? type) {
    switch (type?.toLowerCase()) {
      case 'bill':
        return DocumentType.bill;
      case 'act':
        return DocumentType.act;
      case 'law':
        return DocumentType.law;
      case 'amendment':
        return DocumentType.amendment;
      case 'regulation':
        return DocumentType.regulation;
      default:
        return DocumentType.bill;
    }
  }
}
