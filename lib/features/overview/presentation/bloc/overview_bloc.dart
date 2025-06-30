import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'overview_event.dart';
part 'overview_state.dart';

class OverviewBloc extends Bloc<OverviewEvent, OverviewState> {
  OverviewBloc() : super(OverviewInitial()) {
    on<OverviewEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
