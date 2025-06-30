import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class DeleteFavouriteUsecase
    implements UseCase<List<PropertyModel>, PropertyModel> {
  final FavouritesRepository _repo;

  DeleteFavouriteUsecase(this._repo);

  @override
  Future<Either<Failure, List<PropertyModel>>> call(
    PropertyModel params,
  ) async {
    return await _repo.deleteFavourite(params);
  }
}
