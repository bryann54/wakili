import 'dart:convert';

import 'package:wakili/core/storage/storage_preference_manager.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:injectable/injectable.dart';

@lazySingleton
class FavouritesLocalDatasource {
  final SharedPreferencesManager _sharedPreferencesManager;

  FavouritesLocalDatasource(this._sharedPreferencesManager);

  Future<List<PropertyModel>> listFavourites() async {
    final json = _sharedPreferencesManager.getString(
      SharedPreferencesManager.favourites,
    );
    if (json == null) return [];
    return (jsonDecode(json) as List)
        .map((e) => PropertyModel.fromJson(e))
        .toList();
  }

  Future<List<PropertyModel>?> addFavourite(PropertyModel model) async {
    final favs = await listFavourites();
    final index = favs.indexWhere(
      (element) =>
          element.serpapiPropertyDetailsLink ==
          model.serpapiPropertyDetailsLink,
    );
    if (index != -1) return null;

    final newFavs = [...favs, model];
    _sharedPreferencesManager.putString(
      SharedPreferencesManager.favourites,
      jsonEncode(newFavs),
    );
    return newFavs;
  }

  Future<List<PropertyModel>> deleteFavourite(PropertyModel model) async {
    final favs = await listFavourites();
    final newFavs =
        favs
            .where(
              (element) =>
                  element.serpapiPropertyDetailsLink !=
                  model.serpapiPropertyDetailsLink,
            )
            .toList();
    _sharedPreferencesManager.putString(
      SharedPreferencesManager.favourites,
      jsonEncode(newFavs),
    );
    return newFavs;
  }

  Future<bool> checkIfFav(PropertyModel model) async {
    final favs = await listFavourites();
    final index = favs.indexWhere(
      (element) =>
          element.serpapiPropertyDetailsLink ==
          model.serpapiPropertyDetailsLink,
    );

    return index != -1;
  }
}
