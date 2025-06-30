import 'dart:async';

import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/features/favourites/domain/usecases/add_to_favourites_usecase.dart';
import 'package:wakili/features/favourites/domain/usecases/check_if_fav_usecase.dart';
import 'package:wakili/features/favourites/domain/usecases/delete_favourite_usecase.dart';
import 'package:wakili/features/favourites/domain/usecases/load_favourites_usecase.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

@injectable
class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final LoadFavouritesUsecase _loadFavouritesUsecase;
  final AddToFavouritesUsecase _addToFavouritesUsecase;
  final DeleteFavouriteUsecase _deleteFavouriteUsecase;
  final CheckIfFavUsecase _checkIfFavUsecase;

  FavouritesBloc(
    this._loadFavouritesUsecase,
    this._addToFavouritesUsecase,
    this._deleteFavouriteUsecase,
    this._checkIfFavUsecase,
  ) : super(FavouritesInitial()) {
    on<ListFavouritesEvent>(_listFavourites);
    on<AddFavouriteEvent>(_addFavourite);
    on<DeleteFavouriteEvent>(_deleteFavourite);
    on<CheckIfFavEvent>(_checkIfFav);
  }

  FutureOr<void> _listFavourites(
    ListFavouritesEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(LoadingFavourites());
    final response = await _loadFavouritesUsecase.call(NoParams());
    emit(
      response.fold(
        (error) => LoadFavouritesError(error: error.toString()),
        (favs) => LoadFavouritesSuccess(favs: favs),
      ),
    );
  }

  FutureOr<void> _addFavourite(
    AddFavouriteEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(LoadingFavourites());
    final response = await _addToFavouritesUsecase.call(event.model);
    emit(
      response.fold((error) => AddFavouritesError(error: error.toString()), (
        favs,
      ) {
        add(CheckIfFavEvent(hotel: event.model));
        return AddFavouritesSuccess(favs: favs);
      }),
    );
  }

  FutureOr<void> _deleteFavourite(
    DeleteFavouriteEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(LoadingFavourites());
    final response = await _deleteFavouriteUsecase.call(event.model);
    emit(
      response.fold(
        (error) {
          add(ListFavouritesEvent());
          return DeleteFavouriteError(error: error.toString());
        },
        (favs) {
          add(CheckIfFavEvent(hotel: event.model));
          return DeleteFavouritesSuccess(favs: favs);
        },
      ),
    );
  }

  FutureOr<void> _checkIfFav(
    CheckIfFavEvent event,
    Emitter<FavouritesState> emit,
  ) async {
    emit(LoadingFavourites(hotel: event.hotel));
    final response = await _checkIfFavUsecase.call(event.hotel);
    emit(
      response.fold(
        (error) => CheckIfFavError(error: error.toString()),
        (isFav) => CheckIfFavSuccess(hotel: event.hotel, isFav: isFav),
      ),
    );
  }
}
