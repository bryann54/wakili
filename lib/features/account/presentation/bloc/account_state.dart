part of 'account_bloc.dart';

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountInitial extends AccountState {}

class AccountLoadingState extends AccountState {}

class ChangeLanguageSuccess extends AccountState {
  final String langCode;

  const ChangeLanguageSuccess({required this.langCode});
}

class ChangeLanguageError extends AccountState {
  final String lang;
  final String error;

  const ChangeLanguageError(this.error, {required this.lang});
}
