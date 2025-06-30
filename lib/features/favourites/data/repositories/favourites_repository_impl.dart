import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/favourites/data/datasources/favourites_local_datasource.dart';
import 'package:wakili/features/favourites/domain/repositories/favourites_repository.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@LazySingleton(as: FavouritesRepository)
class FavouritesRepositoryImpl implements FavouritesRepository {
  final FavouritesLocalDatasource _localDatasource;

  FavouritesRepositoryImpl(this._localDatasource);

  @override
  Future<Either<Failure, List<PropertyModel>>> loadFavourites() async {
    final response = await _localDatasource.listFavourites();
    return Right(response);
  }

  @override
  Future<Either<Failure, List<PropertyModel>>> addFavourite(
    PropertyModel model,
  ) async {
    final favs = await _localDatasource.addFavourite(model);
    if (favs != null) return Right(favs);
    return Left(GeneralFailure(error: 'unableToAddToFavs'));
  }

  @override
  Future<Either<Failure, List<PropertyModel>>> deleteFavourite(
    PropertyModel model,
  ) async {
    final favs = await _localDatasource.deleteFavourite(model);
    return Right(favs);
  }

  @override
  Future<Either<Failure, bool>> checkIfFav(PropertyModel model) async {
    return Right(await _localDatasource.checkIfFav(model));
  }
}
