import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/legal_document.dart';
import '../../domain/repositories/legal_document_repository.dart';
import '../models/legal_document_model.dart';

@LazySingleton(as: LegalDocumentRepository)
class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'bills'; 

  LegalDocumentRepositoryImpl(this._firestore);

  @override
  Future<PaginatedResult<LegalDocument>> getLegalDocuments(
      DocumentQuery query) async {
    try {
      Query<Map<String, dynamic>> firestoreQuery = _firestore
          .collection(_collectionName)
          .orderBy(query.orderBy as Object, descending: query.descending);

      // Apply type filter
      if (query.filterType != null) {
        firestoreQuery =
            firestoreQuery.where('type', isEqualTo: query.filterType!.name);
      }

      // Handle pagination
      if (query.startAfterDocumentId != null) {
        final startAfterDoc = await _firestore
            .collection(_collectionName)
            .doc(query.startAfterDocumentId!)
            .get();

        if (startAfterDoc.exists) {
          firestoreQuery = firestoreQuery.startAfterDocument(startAfterDoc);
        }
      }

      // Limit results 
      firestoreQuery = firestoreQuery.limit(query.limit + 1);

      final querySnapshot = await firestoreQuery.get();

      // Convert documents
      List<LegalDocument> documents = querySnapshot.docs
          .map((doc) => LegalDocumentModel.fromFirestore(doc))
          .toList();

      // Check if there are more results
      final hasMore = documents.length > query.limit;
      if (hasMore) {
        documents.removeLast(); 
      }

      // Apply local search filtering if needed
      if (query.searchQuery != null && query.searchQuery!.isNotEmpty) {
        documents = _applyLocalSearch(documents, query.searchQuery!);
      }

      // Get next page token
      final nextPageToken =
          hasMore && documents.isNotEmpty ? documents.last.id : null;

      return PaginatedResult(
        items: documents,
        hasMore: hasMore,
        nextPageToken: nextPageToken,
        totalCount: documents.length,
      );
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch legal documents: ${e.toString()}');
    }
  }

  @override
  Future<LegalDocument?> getDocumentById(String id) async {
    try {
      final doc = await _firestore.collection(_collectionName).doc(id).get();

      if (doc.exists) {
        return LegalDocumentModel.fromFirestore(doc);
      }
      return null;
    } on FirebaseException catch (e) {
      throw Exception('Firestore error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch document: ${e.toString()}');
    }
  }

  @override
  Future<PaginatedResult<LegalDocument>> searchDocuments(
    String searchQuery, {
    DocumentType? filterType,
    int limit = 5,
    String? startAfterDocumentId,
  }) async {
    // For now, we'll do client-side search since Firestore doesn't support full-text search
    // In production, consider using Algolia or Firebase's full-text search extensions
    final query = DocumentQuery(
      searchQuery: searchQuery,
      filterType: filterType,
      limit: limit * 2, // Get more to account for filtering
      startAfterDocumentId: startAfterDocumentId,
    );

    return getLegalDocuments(query);
  }

  @override
  Future<PaginatedResult<LegalDocument>> getDocumentsByType(
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

  @override
  Future<PaginatedResult<LegalDocument>> getRecentDocuments({
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
