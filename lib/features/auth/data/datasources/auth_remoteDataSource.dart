import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';

import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(String email, String password);
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn;

  @override
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().map((user) {
      if (user == null) {
        return null;
      }
      return UserModel.fromFirebaseUser(user);
    });
  }

  @override
  Future<UserModel> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException();
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException {
      throw ServerException(); // Map Firebase errors to your exceptions
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException();
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException {
      throw ServerException(); // Map Firebase errors to your exceptions
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw ClientException(message: 'Google Sign In cancelled.');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final auth.AuthCredential credential = auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _firebaseAuth.signInWithCredential(
        credential,
      );
      if (userCredential.user == null) {
        throw ServerException();
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException {
      throw ServerException(); // Map Firebase errors to your exceptions
    } on ClientException {
      rethrow; // Re-throw the specific client cancellation
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut(); // Sign out from Google too
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException {
      throw ServerException();
    } catch (e) {
      throw ServerException();
    }
  }
}
