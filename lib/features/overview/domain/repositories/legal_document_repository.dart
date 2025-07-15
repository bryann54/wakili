import '../entities/legal_document.dart';

abstract class LegalDocumentRepository {
  /// Get paginated legal documents
  Future<PaginatedResult<LegalDocument>> getLegalDocuments(DocumentQuery query);
  
  /// Get a single document by ID
  Future<LegalDocument?> getDocumentById(String id);
  
  /// Search documents with pagination
  Future<PaginatedResult<LegalDocument>> searchDocuments(
    String searchQuery, {
    DocumentType? filterType,
    int limit = 5,
    String? startAfterDocumentId,
  });
  
  /// Get documents by type with pagination
  Future<PaginatedResult<LegalDocument>> getDocumentsByType(
    DocumentType type, {
    int limit = 5,
    String? startAfterDocumentId,
  });
  
  /// Get recent documents
  Future<PaginatedResult<LegalDocument>> getRecentDocuments({
    int limit = 5,
    String? startAfterDocumentId,
  });
}