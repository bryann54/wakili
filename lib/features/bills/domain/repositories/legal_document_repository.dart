import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import '../entities/legal_document.dart';

abstract class LegalDocumentRepository {
  /// Get paginated legal documents
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getLegalDocuments(
      DocumentQuery query);

  /// Get a single document by ID
  Future<Either<Failure, LegalDocument?>> getDocumentById(String id);

  /// Search documents with pagination
  Future<Either<Failure, PaginatedResult<LegalDocument>>> searchDocuments(
    String searchQuery, {
    DocumentType? filterType,
    int limit = 5,
    String? startAfterDocumentId,
  });

  /// Get documents by type with pagination
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getDocumentsByType(
    DocumentType type, {
    int limit = 5,
    String? startAfterDocumentId,
  });

  /// Get recent documents
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getRecentDocuments({
    int limit = 5,
    String? startAfterDocumentId,
  });
}
