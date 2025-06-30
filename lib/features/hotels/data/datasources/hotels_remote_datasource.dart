import 'package:wakili/core/api_client/client_provider.dart';
import 'package:wakili/features/hotels/data/models/query_hotel_model.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class HotelsRemoteDatasource {
  final ClientProvider _clientProvider;

  HotelsRemoteDatasource(this._clientProvider);

  Future<dynamic> listHotels(QueryHotelModel queryHotelModel) async {
    try {
      return await _clientProvider.get(query: queryHotelModel.toJson());
    } catch (e) {
      if (kDebugMode) {
        debugPrint('listHotels response: $e');
      }
      rethrow;
    }
  }
}
