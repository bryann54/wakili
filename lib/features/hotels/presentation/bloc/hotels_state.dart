part of 'hotels_bloc.dart';

abstract class HotelsState extends Equatable {
  const HotelsState();

  @override
  List<Object> get props => [];
}

class HotelsInitial extends HotelsState {}

class HotelsLoadingState extends HotelsState {}

class LoadingMore extends HotelsState {}

class ListHotelsSuccess extends HotelsState {
  final List<PropertyModel> hotels;

  const ListHotelsSuccess({required this.hotels});
}

class ListHotelsError extends HotelsState {
  final String error;

  const ListHotelsError({required this.error});
}
