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
  final String? sourceUrl;

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
    this.sourceUrl,
  });
}

enum DocumentType { bill, act, law, amendment, regulation }

// Pagination result wrapper
class PaginatedResult<T> {
  final List<T> items;
  final bool hasMore;
  final String? nextPageToken;
  final int totalCount;

  const PaginatedResult({
    required this.items,
    required this.hasMore,
    this.nextPageToken,
    this.totalCount = 0,
  });
}

// Query parameters for better organization
class DocumentQuery {
  final DocumentType? filterType;
  final String? searchQuery;
  final int limit;
  final String? startAfterDocumentId;
  final String? orderBy;
  final bool descending;

  const DocumentQuery({
    this.filterType,
    this.searchQuery,
    this.limit = 10,
    this.startAfterDocumentId,
    this.orderBy = 'datePublished',
    this.descending = true,
  });

  DocumentQuery copyWith({
    DocumentType? filterType,
    String? searchQuery,
    int? limit,
    String? startAfterDocumentId,
    String? orderBy,
    bool? descending,
  }) {
    return DocumentQuery(
      filterType: filterType ?? this.filterType,
      searchQuery: searchQuery ?? this.searchQuery,
      limit: limit ?? this.limit,
      startAfterDocumentId: startAfterDocumentId ?? this.startAfterDocumentId,
      orderBy: orderBy ?? this.orderBy,
      descending: descending ?? this.descending,
    );
  }
}
