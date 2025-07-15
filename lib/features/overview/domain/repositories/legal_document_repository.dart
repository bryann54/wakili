import '../entities/legal_document.dart';

abstract class LegalDocumentRepository {
  Future<List<LegalDocument>> getLegalDocuments({
    DocumentType? filterType,
    String? searchQuery,
  });
}
