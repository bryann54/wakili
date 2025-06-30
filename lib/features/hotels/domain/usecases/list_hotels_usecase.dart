import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/hotels/data/models/query_hotel_model.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/domain/repositories/hotels_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class ListHotelsUsecase implements UseCase<SearchResponse, GetHotelsParams> {
  final HotelsRepository _repo;

  ListHotelsUsecase(this._repo);

  @override
  Future<Either<Failure, SearchResponse>> call(GetHotelsParams params) async {
    return await _repo.listHotels(QueryHotelModel(
      engine: params.engine,
      q: params.q.isEmpty ? 'Bali Hotels' : params.q,
      gl: params.gl,
      hl: params.hl,
      currency: params.currency,
      checkInDate: params.checkInDate,
      checkOutDate: params.checkOutDate,
      nextPageToken: params.nextPageToken,
    ));
  }
}
