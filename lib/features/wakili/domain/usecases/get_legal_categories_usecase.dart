import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';
import 'package:wakili/features/wakili/domain/repositories/legal_category_repository.dart';

@injectable
class GetLegalCategoriesUseCase {
  final LegalCategoryRepository _repository;

  GetLegalCategoriesUseCase(this._repository);

  Future<Either<Failure, List<LegalCategory>>> call() {
    return _repository.getLegalCategories();
  }
}
