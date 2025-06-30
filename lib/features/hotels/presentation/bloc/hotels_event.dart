part of 'hotels_bloc.dart';

abstract class HotelsEvent extends Equatable {
  const HotelsEvent();

  @override
  List<Object> get props => [];
}

class ListHotelsEvent extends HotelsEvent {
  final GetHotelsParams params;

  const ListHotelsEvent({required this.params});
}

class LoadMoreHotelsEvent extends HotelsEvent {
  final GetHotelsParams params;

  const LoadMoreHotelsEvent({required this.params});
}
