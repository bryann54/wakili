import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoUrl;

  const UserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoUrl,
  });

  factory UserEntity.fromFirebaseUser(auth.User user) {
    return UserEntity(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
    );
  }

  @override
  List<Object?> get props => [uid, email, displayName, photoUrl];
}
