part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthSignInWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;

  const AuthSignInWithEmailAndPassword({
    required this.email,
    required this.password,
  });

  @override
  List<Object> get props => [email, password];
}

class AuthSignUpWithEmailAndPassword extends AuthEvent {
  final String email;
  final String password;
  final String firstName;
  final String lastName;

  const AuthSignUpWithEmailAndPassword({
    required this.email,
    required this.password,
    required this.firstName,
    required this.lastName,
  });

  @override
  List<Object> get props => [
        email,
        password,
        firstName,
        lastName
      ]; // ADDED firstName, lastName to props
}

class AuthSignInWithGoogle extends AuthEvent {
  const AuthSignInWithGoogle();
}

class AuthSignOut extends AuthEvent {
  const AuthSignOut();
}

class AuthCheckStatus extends AuthEvent {
  const AuthCheckStatus();
}

class AuthResetPassword extends AuthEvent {
  final String email;

  const AuthResetPassword({required this.email});

  @override
  List<Object> get props => [email];
}
