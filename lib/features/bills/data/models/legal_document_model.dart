import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wakili/features/bills/domain/entities/legal_document.dart';

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
    super.sourceUrl,
  });

  factory LegalDocumentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return LegalDocumentModel(
      id: doc.id,
      title: data['title'] ?? '',
      summary: data['summary'] ?? '',
      content: data['content'] ?? '',
      type: _parseDocumentType(data['type']),
      datePublished: _parseTimestamp(data['datePublished']),
      status: data['status'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      parliamentaryStage: data['parliamentaryStage'] ?? '',
      sponsor: data['sponsor'] ?? '',
      sourceUrl: data['sourceUrl'],
    );
  }

  // Keep the JSON factory for backward compatibility
  factory LegalDocumentModel.fromJson(Map<String, dynamic> json) {
    return LegalDocumentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      summary: json['summary'] ?? '',
      content: json['content'] ?? '',
      type: _parseDocumentType(json['type']),
      datePublished: _parseTimestamp(json['datePublished']),
      status: json['status'] ?? '',
      tags: List<String>.from(json['tags'] ?? []),
      parliamentaryStage: json['parliamentaryStage'] ?? '',
      sponsor: json['sponsor'] ?? '',
      sourceUrl: json['sourceUrl'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'summary': summary,
      'content': content,
      'type': type.name,
      'datePublished': Timestamp.fromDate(datePublished),
      'status': status,
      'tags': tags,
      'parliamentaryStage': parliamentaryStage,
      'sponsor': sponsor,
      if (sourceUrl != null) 'sourceUrl': sourceUrl,
    };
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

  static DateTime _parseTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    }
    if (timestamp is String) {
      return DateTime.tryParse(timestamp) ?? DateTime.now();
    }
    return DateTime.now();
  }
}
