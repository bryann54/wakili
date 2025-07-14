import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';

@injectable
class LegalCategoryRemoteDataSource {
  final FirebaseFirestore _firestore;

  LegalCategoryRemoteDataSource(this._firestore);

  Future<List<LegalCategory>> getLegalCategories() async {
    try {
      final querySnapshot =
          await _firestore.collection('legalCategories').get();
      return querySnapshot.docs
          .map((doc) => LegalCategory.fromFirestore(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch legal categories: $e');
    }
  }
}
