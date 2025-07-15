import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import '../../domain/entities/legal_document.dart';
import '../../domain/repositories/legal_document_repository.dart';
import '../models/legal_document_model.dart'; 

@LazySingleton(as: LegalDocumentRepository)
class LegalDocumentRepositoryImpl implements LegalDocumentRepository {
  final FirebaseFirestore _firestore;

  LegalDocumentRepositoryImpl(this._firestore);

  @override
  Future<List<LegalDocument>> getLegalDocuments({
    DocumentType? filterType,
    String? searchQuery,
  }) async {
    try {
      Query<Map<String, dynamic>> query =
          _firestore.collection('bills');

      if (filterType != null) {
        query = query.where('type', isEqualTo: filterType.name);
      }
      final querySnapshot = await query.get();

      List<LegalDocument> documents = querySnapshot.docs
          .map((doc) => LegalDocumentModel.fromJson(doc.data()))
          .toList();

      if (searchQuery != null && searchQuery.isNotEmpty) {
        documents = documents
            .where((doc) =>
                doc.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                doc.summary.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();
      }

      return documents;
    } on FirebaseException catch (e) {
      throw Exception('Firestore error fetching documents: ${e.message}');
    } catch (e) {
      throw Exception('Failed to fetch legal documents: ${e.toString()}');
    }
  }
}
