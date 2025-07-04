import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;
  final String? firstName;
  final String? lastName;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
    this.firstName,
    this.lastName,
  });

  factory UserEntity.fromFirebaseUser(auth.User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      firstName: user.displayName?.split(' ').first ?? '',
      lastName:
          user.displayName != null && user.displayName!.split(' ').length > 1
              ? user.displayName!.split(' ').sublist(1).join(' ')
              : '',
    );
  }

  @override
  List<Object?> get props =>
      [uid, email, displayName, photoUrl, firstName, lastName];
}
