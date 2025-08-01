import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';

// Define a simple class to hold the pagination result
class LegalCategoryQueryResult {
  final List<LegalCategory> categories;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  LegalCategoryQueryResult({
    required this.categories,
    this.lastDocument,
    required this.hasMore,
  });
}

@injectable
class LegalCategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  LegalCategoryRemoteDataSource(this._firestore);

  // Updated method signature for pagination
  Future<LegalCategoryQueryResult> getLegalCategories({
    DocumentSnapshot? lastDocument,
    int limit = 6, // Default limit is 6
  }) async {
    try {
      Query query = _firestore
          .collection('legalCategories')
          .orderBy('title'); // Order by a field for consistent pagination

      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument);
      }

      final querySnapshot = await query
          .limit(limit + 1)
          .get(); // Fetch one more to check if there's a next page

      final List<LegalCategory> categories = querySnapshot.docs
          .take(limit) // Take only the requested limit
          .map((doc) => LegalCategory.fromFirestore(
              doc.data() as Map<String, dynamic>, doc.id))
          .toList();

      final bool hasMore = querySnapshot.docs.length > limit;
      final DocumentSnapshot? newLastDocument =
          hasMore ? querySnapshot.docs[limit - 1] : null;

      return LegalCategoryQueryResult(
        categories: categories,
        lastDocument: newLastDocument ??
            (querySnapshot.docs.isNotEmpty ? querySnapshot.docs.last : null),
        hasMore: hasMore,
      );
    } catch (e) {
      throw Exception('Failed to fetch legal categories: $e');
    }
  }
}
