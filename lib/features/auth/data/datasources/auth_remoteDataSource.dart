// lib/features/auth/data/datasources/auth_remoteDataSource.dart

import 'dart:io'; // For File
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:uuid/uuid.dart'; // Import Uuid
import 'package:wakili/common/utils/google_sign_in.dart';
import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AuthRemoteDataSource {
  Stream<UserModel?> get authStateChanges;
  Future<UserModel> signInWithEmailAndPassword(String email, String password);
  Future<UserModel> signUpWithEmailAndPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      File? profileImage); // Added profileImage
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  // Removed uploadProfileImage method as it's integrated into signUp
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage _firebaseStorage; // Injected
  final Uuid _uuid; // Injected

  AuthRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseStorage firebaseStorage, // Add to constructor
    required Uuid uuid, // Add to constructor
  })  : _firebaseAuth = firebaseAuth,
        _googleSignIn = googleSignIn,
        _firebaseStorage = firebaseStorage,
        _uuid = uuid;

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
      throw ServerException(message: getFirebaseAuthErrorMessage(e.code));
    } catch (e) {
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
    File? profileImage, // Added profileImage
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

      final auth.User user = userCredential.user!;

      // Update display name
      await user.updateDisplayName('$firstName $lastName');

      String? photoUrl;
      // Upload profile image if provided
      if (profileImage != null) {
        try {
          final String fileName =
              'profile_images/${user.uid}/${_uuid.v4()}.jpg';
          final Reference storageRef = _firebaseStorage.ref().child(fileName);

          final UploadTask uploadTask = storageRef.putFile(profileImage);
          final TaskSnapshot snapshot = await uploadTask;
          photoUrl = await snapshot.ref.getDownloadURL();
          await user
              .updatePhotoURL(photoUrl); // Update Firebase Auth user's photoURL
        } on FirebaseException catch (e) {
          // Log or handle the image upload error separately, but don't block user creation
          print('Error uploading profile image: ${e.message}');
          // You might choose to throw ServerException here if image upload is critical,
          // or just proceed without a photoUrl. For this example, we proceed.
        }
      }

      // Reload user to ensure photoURL is updated in the current session
      await user.reload();
      // Get the current user instance from FirebaseAuth after reload
      final updatedUser = _firebaseAuth.currentUser;

      // Return UserModel from the potentially updated user, or the original if reload failed
      return UserModel.fromFirebaseUser(updatedUser ?? user);
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
      rethrow;
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
