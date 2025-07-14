import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/wakili/data/models/legal_category.dart';

abstract class LegalCategoryRepository {
  Future<Either<Failure, List<LegalCategory>>> getLegalCategories();
}
