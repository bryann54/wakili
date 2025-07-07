import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/features/auth/domain/entities/user_entity.dart';
import 'package:wakili/features/auth/domain/usecases/auth_usecases.dart';
part 'auth_event.dart';
part 'auth_state.dart';

@injectable
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailAndPasswordUseCase signInWithEmailAndPasswordUseCase;
  final SignUpWithEmailAndPasswordUseCase signUpWithEmailAndPasswordUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignOutUseCase signOutUseCase;
  final GetAuthStateChangesUseCase getAuthStateChangesUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  AuthBloc({
    required this.signInWithEmailAndPasswordUseCase,
    required this.signUpWithEmailAndPasswordUseCase,
    required this.signInWithGoogleUseCase,
    required this.signOutUseCase,
    required this.getAuthStateChangesUseCase,
    required this.resetPasswordUseCase,
  }) : super(AuthInitial()) {
    on<AuthCheckStatus>(_onAuthCheckStatus);
    on<AuthSignInWithEmailAndPassword>(_onAuthSignInWithEmailAndPassword);
    on<AuthSignUpWithEmailAndPassword>(_onAuthSignUpWithEmailAndPassword);
    on<AuthSignInWithGoogle>(_onAuthSignInWithGoogle);
    on<AuthSignOut>(_onAuthSignOut);
    on<AuthResetPassword>(_onAuthResetPassword);
    on<AuthStatusChanged>(_onAuthStatusChanged); 

    getAuthStateChangesUseCase().listen((user) {
      add(AuthStatusChanged(user)); 
    });
  }

  FutureOr<void> _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) async {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthCheckStatus(
    AuthCheckStatus event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final user = await getAuthStateChangesUseCase().first;
    if (user != null) {
      emit(AuthAuthenticated(user: user));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  FutureOr<void> _onAuthSignInWithEmailAndPassword(
    AuthSignInWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithEmailAndPasswordUseCase(
      event.email,
      event.password,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  FutureOr<void> _onAuthSignUpWithEmailAndPassword(
    AuthSignUpWithEmailAndPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signUpWithEmailAndPasswordUseCase(
      event.email,
      event.password,
      event.firstName,
      event.lastName,
    );
    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  FutureOr<void> _onAuthSignInWithGoogle(
    AuthSignInWithGoogle event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithGoogleUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (user) => emit(AuthAuthenticated(user: user)),
    );
  }

  FutureOr<void> _onAuthSignOut(
    AuthSignOut event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOutUseCase();
    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (_) => emit(AuthUnauthenticated()),
    );
  }

  FutureOr<void> _onAuthResetPassword(
    AuthResetPassword event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await resetPasswordUseCase(event.email);
    result.fold(
      (failure) => emit(AuthError(message: failure.toString())),
      (_) => emit(AuthPasswordResetSent()),
    );
  }
}
