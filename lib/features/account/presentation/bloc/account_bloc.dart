// lib/features/account/presentation/bloc/account_bloc.dart

import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/account/domain/usecases/update_user_profile_usecase.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UpdateUserProfileUseCase updateUserProfileUseCase;

  AccountBloc({required this.updateUserProfileUseCase})
      : super(AccountInitial()) {
    on<UpdateUserProfile>(_onUpdateUserProfile);
  }

  FutureOr<void> _onUpdateUserProfile(
    UpdateUserProfile event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoading());
    final result = await updateUserProfileUseCase(
      firstName: event.firstName,
      lastName: event.lastName,
      profileImage: event.profileImage,
    );
    result.fold(
      (failure) => emit(AccountError(message: failure.toString())),
      (user) => emit(AccountProfileUpdated(user: user)),
    );
  }
}
