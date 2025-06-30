part of 'favourites_bloc.dart';

abstract class FavouritesState extends Equatable {
  const FavouritesState();

  @override
  List<Object> get props => [];
}

class FavouritesInitial extends FavouritesState {}

class LoadingFavourites extends FavouritesState {
  final PropertyModel? hotel;

  const LoadingFavourites({this.hotel});
}

class LoadFavouritesError extends FavouritesState {
  final String error;

  const LoadFavouritesError({required this.error});
}

class LoadFavouritesSuccess extends FavouritesState {
  final List<PropertyModel> favs;

  const LoadFavouritesSuccess({required this.favs});
}

class DeleteFavouritesSuccess extends FavouritesState {
  final List<PropertyModel> favs;

  const DeleteFavouritesSuccess({required this.favs});
}

class DeleteFavouriteError extends FavouritesState {
  final String error;

  const DeleteFavouriteError({required this.error});
}

class AddFavouritesSuccess extends FavouritesState {
  final List<PropertyModel> favs;

  const AddFavouritesSuccess({required this.favs});
}

class AddFavouritesError extends FavouritesState {
  final String error;

  const AddFavouritesError({required this.error});
}

class CheckIfFavSuccess extends FavouritesState {
  final PropertyModel hotel;
  final bool isFav;

  const CheckIfFavSuccess({required this.hotel, required this.isFav});
}

class CheckIfFavError extends FavouritesState {
  final String error;

  const CheckIfFavError({required this.error});
}
