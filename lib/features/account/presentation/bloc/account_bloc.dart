import 'dart:async';

import 'package:wakili/features/account/domain/usecases/change_language_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

part 'account_event.dart';
part 'account_state.dart';

@injectable
class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final ChangeLanguageUsecase _changeLanguageUsecase;
  AccountBloc(this._changeLanguageUsecase) : super(AccountInitial()) {
    on<ChangeLanguageEvent>(_changeLanguage);
  }

  FutureOr<void> _changeLanguage(
    ChangeLanguageEvent event,
    Emitter<AccountState> emit,
  ) async {
    emit(AccountLoadingState());
    final response = await _changeLanguageUsecase.call(event.langCode);
    emit(
      response.fold(
        (err) => ChangeLanguageError(err.toString(), lang: event.langCode),
        (_) => ChangeLanguageSuccess(langCode: event.langCode),
      ),
    );
  }
}
