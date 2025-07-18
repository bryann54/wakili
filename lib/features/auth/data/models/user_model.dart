import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:wakili/features/auth/domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  const UserModel({
    required super.uid,
    super.email,
    super.displayName,
    super.photoUrl,
    super.firstName,
    super.lastName,
  });

  factory UserModel.fromFirebaseUser(auth.User user) {
    return UserModel(
      uid: user.uid,
      email: user.email,
      displayName: user.displayName,
      photoUrl: user.photoURL,
      firstName: user.displayName?.split(' ').first ?? '',
      lastName: user.displayName?.split(' ').length == 2
          ? user.displayName?.split(' ').last
          : '',
    );
  }
}
