import 'dart:async';

import 'package:wakili/common/helpers/base_usecase.dart';
import 'package:wakili/core/storage/storage_preference_manager.dart';
import 'package:wakili/features/hotels/data/models/search_response.dart';
import 'package:wakili/features/hotels/domain/usecases/list_hotels_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'hotels_event.dart';
part 'hotels_state.dart';

@injectable
class HotelsBloc extends Bloc<HotelsEvent, HotelsState> {
  final SharedPreferencesManager _preferencesManager;
  final ListHotelsUsecase _listHotelsUsecase;
  final List<PropertyModel> hotels = [];
  late SerpApiPagination pagination;

  HotelsBloc(this._listHotelsUsecase, this._preferencesManager)
      : super(HotelsInitial()) {
    on<ListHotelsEvent>(_listHotels);
    on<LoadMoreHotelsEvent>(_loadMore);
  }

  FutureOr<void> _listHotels(
      ListHotelsEvent event, Emitter<HotelsState> emit) async {
    emit(HotelsLoadingState());
    final params = event.params.copyWith(
        hl: _preferencesManager.getString(SharedPreferencesManager.language));
    final response = await _listHotelsUsecase.call(params);
    emit(response.fold(
      (error) => ListHotelsError(error: error.toString()),
      (response) {
        hotels.clear();
        hotels.addAll(response.properties);
        pagination = response.pagination;
        return ListHotelsSuccess(hotels: hotels);
      },
    ));
  }

  FutureOr<void> _loadMore(
      LoadMoreHotelsEvent event, Emitter<HotelsState> emit) async {
    emit(LoadingMore());
    final params =
        event.params.copyWith(nextPageToken: pagination.nextPageToken);
    final response = await _listHotelsUsecase.call(params);
    emit(response.fold(
      (error) => ListHotelsSuccess(hotels: hotels),
      (more) {
        hotels.addAll(more.properties);
        pagination.nextPageToken = more.pagination.nextPageToken;
        pagination.currentFrom = more.pagination.currentFrom;
        pagination.currentTo = more.pagination.currentTo;
        return ListHotelsSuccess(hotels: hotels);
      },
    ));
  }
}
