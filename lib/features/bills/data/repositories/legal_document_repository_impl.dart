import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:dartz/dartz.dart'; // Import Either
import 'package:wakili/core/errors/failures.dart'; // Import your Failure types
import 'package:wakili/core/errors/exceptions.dart'; // Import your Exception types
import '../../domain/entities/legal_document.dart';
import '../../domain/repositories/legal_document_repository.dart';
import '../models/legal_document_model.dart';

@LazySingleton(as: LegalDocumentRepository)
class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'legal_documents';

  LegalDocumentRepositoryImpl(this._firestore);

  @override
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getLegalDocuments(
      DocumentQuery query) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _firestore
          .collection(_collectionName)
          .orderBy(query.orderBy as Object, descending: query.descending);

      if (query.filterType != null) {
        firestoreQuery =
            firestoreQuery.where('type', isEqualTo: query.filterType!.name);
      }

      if (query.startAfterDocumentId != null) {
        final startAfterDoc = await _firestore
            .collection(_collectionName)
            .doc(query.startAfterDocumentId!)
            .get();

        if (startAfterDoc.exists) {
          firestoreQuery = firestoreQuery.startAfterDocument(startAfterDoc);
        } else {
          // If startAfterDocumentId does not exist, it might be an invalid ID
          // or end of documents. Handle gracefully, e.g., return empty list.
          // Or, you can treat this as a ClientFailure.
          return const Right(PaginatedResult(
              items: [], hasMore: false, nextPageToken: null, totalCount: 0));
        }
      }

      firestoreQuery = firestoreQuery.limit(query.limit + 1);

      final querySnapshot = await firestoreQuery.get();

      List<LegalDocument> documents = querySnapshot.docs
          .map((doc) => LegalDocumentModel.fromFirestore(doc))
          .toList();

      final hasMore = documents.length > query.limit;
      if (hasMore) {
        documents.removeLast();
      }

      if (query.searchQuery != null && query.searchQuery!.isNotEmpty) {
        documents = _applyLocalSearch(documents, query.searchQuery!);
      }

      final nextPageToken =
          hasMore && documents.isNotEmpty ? documents.last.id : null;

      return Right(PaginatedResult(
        items: documents,
        hasMore: hasMore,
        nextPageToken: nextPageToken,
        totalCount: documents.length,
      ));
    } on FirebaseException catch (e) {
      // Map FirebaseException to ServerFailure or ConnectionFailure
      // Depending on the specific Firebase error code.
      // For simplicity, converting to ServerFailure here.
      return Left(ServerFailure(
          message: e.message ?? 'Firestore operation failed',
          statusCode: e.code
              .hashCode)); // Using hashCode as a placeholder for status code
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message));
    } on Exception catch (e) {
      return Left(GeneralFailure(
          message: 'An unexpected error occurred: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, LegalDocument?>> getDocumentById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return Right(LegalDocumentModel.fromFirestore(doc));
      }
      return const Right(
          null); // Document not found is a valid scenario, not a failure
    } on FirebaseException catch (e) {
      return Left(ServerFailure(
          message: e.message ?? 'Firestore operation failed',
          statusCode: e.code.hashCode));
    } on Exception catch (e) {
      return Left(
          GeneralFailure(message: 'Failed to fetch document: ${e.toString()}'));
    }
  }

  // Refactored to call getLegalDocuments and return its Either<Failure, PaginatedResult>
  @override
  Future<Either<Failure, PaginatedResult<LegalDocument>>> searchDocuments(
    String searchQuery, {
    DocumentType? filterType,
    int limit = 5,
    String? startAfterDocumentId,
  }) async {
    final query = DocumentQuery(
      searchQuery: searchQuery,
      filterType: filterType,
      limit: limit * 2, // Get more to account for local filtering
      startAfterDocumentId: startAfterDocumentId,
    );
    return getLegalDocuments(query);
  }

  // Refactored to call getLegalDocuments and return its Either<Failure, PaginatedResult>
  @override
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getDocumentsByType(
    DocumentType type, {
    int limit = 5,
    String? startAfterDocumentId,
  }) async {
    final query = DocumentQuery(
      filterType: type,
      limit: limit,
      startAfterDocumentId: startAfterDocumentId,
    );
    return getLegalDocuments(query);
  }

  // Refactored to call getLegalDocuments and return its Either<Failure, PaginatedResult>
  @override
  Future<Either<Failure, PaginatedResult<LegalDocument>>> getRecentDocuments({
    int limit = 5,
    String? startAfterDocumentId,
  }) async {
    final query = DocumentQuery(
      limit: limit,
      startAfterDocumentId: startAfterDocumentId,
      orderBy: 'datePublished',
      descending: true,
    );
    return getLegalDocuments(query);
  }

  // Helper method for local search filtering
  List<LegalDocument> _applyLocalSearch(
    List<LegalDocument> documents,
    String searchQuery,
  ) {
    final query = searchQuery.toLowerCase();
    return documents.where((doc) {
      return doc.title.toLowerCase().contains(query) ||
          doc.summary.toLowerCase().contains(query) ||
          doc.content.toLowerCase().contains(query) ||
          doc.tags.any((tag) => tag.toLowerCase().contains(query));
    }).toList();
  }
}
