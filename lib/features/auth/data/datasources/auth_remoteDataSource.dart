// lib/features/auth/data/datasources/auth_remoteDataSource.dart

import 'dart:io'; // For File
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_storage/firebase_storage.dart'; 
import 'package:uuid/uuid.dart'; 
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
      File? profileImage); 
  Future<UserModel> signInWithGoogle();
  Future<void> signOut();
  Future<void> resetPassword(String email);
}

@LazySingleton(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;
  final FirebaseStorage _firebaseStorage;
  final Uuid _uuid; 

  AuthRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required GoogleSignIn googleSignIn,
    required FirebaseStorage firebaseStorage, 
    required Uuid uuid, 
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
    File? profileImage, 
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

      await user.updateDisplayName('$firstName $lastName');

      String? photoUrl;
      if (profileImage != null) {
        try {
          final String fileName =
              'profile_images/${user.uid}/${_uuid.v4()}.jpg';
          final Reference storageRef = _firebaseStorage.ref().child(fileName);

          final UploadTask uploadTask = storageRef.putFile(profileImage);
          final TaskSnapshot snapshot = await uploadTask;
          photoUrl = await snapshot.ref.getDownloadURL();
          await user
              .updatePhotoURL(photoUrl); 
        } on FirebaseException catch (e) {
          debugPrint('Error uploading profile image: ${e.message}');
        }
      }

      await user.reload();
      final updatedUser = _firebaseAuth.currentUser;

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
