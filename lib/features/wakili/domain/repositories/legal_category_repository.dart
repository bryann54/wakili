import 'package:cloud_firestore/cloud_firestore.dart'; // Import for DocumentSnapshot
import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/datasources/legal_category_remote_datasource.dart'; // Import the query result

abstract class LegalCategoryRepository {
  // Updated method to return LegalCategoryQueryResult
  Future<Either<Failure, LegalCategoryQueryResult>> getLegalCategories({
    DocumentSnapshot? lastDocument,
    int limit = 6,
  });
}
