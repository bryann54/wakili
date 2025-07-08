import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wakili/common/utils/google_sign_in.dart';

import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String email, String password, String firstName, String lastName);
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
        throw ServerException(
            message: 'User credential is null after sign-in.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      // Map Firebase specific error codes to custom messages
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      // Catch any other unexpected errors
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user == null) {
        throw ServerException(
            message: 'User credential is null after sign-up.');
      }
      await userCredential.user!.updateDisplayName('$firstName $lastName');
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<UserModel> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // User cancelled the sign-in flow
        throw ClientException(message: 'Google Sign In cancelled by user.');
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
        throw ServerException(
            message: 'User credential is null after Google sign-in.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } on ClientException {
      rethrow; // Re-throw the specific client cancellation
    } catch (e) {
      throw ServerException(
          message: 'An unexpected error occurred: ${e.toString()}');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      throw ServerException(
          message:
              'An unexpected error occurred during sign out: ${e.toString()}');
    }
  }

  @override
  Future<void> resetPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
      throw ServerException(
          message:
              'An unexpected error occurred during password reset: ${e.toString()}');
    }
  }
}
