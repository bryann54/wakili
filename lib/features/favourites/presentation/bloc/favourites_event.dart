part of 'favourites_bloc.dart';

abstract class FavouritesEvent extends Equatable {
  const FavouritesEvent();

  @override
  List<Object> get props => [];
}

class ListFavouritesEvent extends FavouritesEvent {}

class AddFavouriteEvent extends FavouritesEvent {
  final PropertyModel model;

  const AddFavouriteEvent({required this.model});
}

class DeleteFavouriteEvent extends FavouritesEvent {
  final PropertyModel model;

  const DeleteFavouriteEvent({required this.model});
}

class CheckIfFavEvent extends FavouritesEvent {
  final PropertyModel hotel;

  const CheckIfFavEvent({required this.hotel});
}
