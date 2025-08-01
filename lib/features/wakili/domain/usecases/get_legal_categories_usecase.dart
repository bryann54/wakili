import 'package:cloud_firestore/cloud_firestore.dart'; // Import for DocumentSnapshot
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/domain/repositories/legal_category_repository.dart';

// Define a simple class to hold the use case result
class PaginatedLegalCategories {
  final List<LegalCategory> categories;
  final DocumentSnapshot? lastDocument;
  final bool hasMore;

  PaginatedLegalCategories({
    required this.categories,
    this.lastDocument,
    required this.hasMore,
  });
}

@injectable
class GetLegalCategoriesUseCase {
  final LegalCategoryRepository _repository;

  GetLegalCategoriesUseCase(this._repository);

  // Updated method signature for pagination
  Future<Either<Failure, PaginatedLegalCategories>> call({
    DocumentSnapshot? lastDocument,
    int limit = 6,
  }) async {
    final result = await _repository.getLegalCategories(
      lastDocument: lastDocument,
      limit: limit,
    );
    return result.fold(
      (failure) => left(failure),
      (queryResult) => right(
        PaginatedLegalCategories(
          categories: queryResult.categories,
          lastDocument: queryResult.lastDocument,
          hasMore: queryResult.hasMore,
        ),
      ),
    );
  }
}
