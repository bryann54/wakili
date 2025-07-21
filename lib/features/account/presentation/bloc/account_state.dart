// lib/features/account/presentation/bloc/account_state.dart

part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoading extends AccountState {}

class AccountProfileUpdated extends AccountState {
  final UserModel user;

  const AccountProfileUpdated({required this.user});

  @override
  List<Object> get props => [user];
}

class AccountError extends AccountState {
  final String message;

  const AccountError({required this.message});

  @override
  List<Object> get props => [message];
}
