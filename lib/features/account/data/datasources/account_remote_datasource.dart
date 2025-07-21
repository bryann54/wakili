// lib/features/account/data/datasources/account_remote_datasource.dart

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';
import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'package:injectable/injectable.dart';

abstract class AccountRemoteDataSource {
  Future<UserModel> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  });
}

@LazySingleton(as: AccountRemoteDataSource)
class AccountRemoteDataSourceImpl implements AccountRemoteDataSource {
  final auth.FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  AccountRemoteDataSourceImpl({
    required auth.FirebaseAuth firebaseAuth,
    required FirebaseStorage firebaseStorage,
    required FirebaseFirestore firestore,
    required Uuid uuid,
  })  : _firebaseAuth = firebaseAuth,
        _firebaseStorage = firebaseStorage,
        _firestore = firestore,
        _uuid = uuid;

  @override
  Future<UserModel> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  }) async {
    try {
      final user = _firebaseAuth.currentUser;
      if (user == null) {
        throw ServerException(message: 'No user logged in.');
      }

      // Update display name in Firebase Authentication
      final displayName = '$firstName $lastName';
      await user.updateDisplayName(displayName);

      String? photoUrl = user.photoURL;
      if (profileImage != null) {
        try {
          final fileName = 'profile_images/${user.uid}/${_uuid.v4()}.jpg';
          final storageRef = _firebaseStorage.ref().child(fileName);
          final uploadTask = storageRef.putFile(profileImage);
          final snapshot = await uploadTask;
          photoUrl = await snapshot.ref.getDownloadURL();
          await user.updatePhotoURL(photoUrl);
        } catch (e) {
          // Log error but proceed with profile update
          print('Error uploading profile image: $e');
        }
      }

      // Update Firestore user document
      await _firestore.collection('users').doc(user.uid).set({
        'firstName': firstName,
        'lastName': lastName,
        'photoUrl': photoUrl,
        'email': user.email,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      // Reload user to ensure updated data
      await user.reload();
      final updatedUser = _firebaseAuth.currentUser!;
      return UserModel.fromFirebaseUser(updatedUser);
    } on auth.FirebaseAuthException catch (e) {
      throw ServerException(message: e.message ?? 'Firebase Auth error.');
    } catch (e) {
      throw ServerException(message: 'An unexpected error occurred: $e');
    }
  }
}
