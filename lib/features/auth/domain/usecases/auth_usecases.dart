// lib/features/auth/domain/usecases/auth_usecases.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/auth/domain/entities/user_entity.dart';
import 'package:wakili/features/auth/domain/repositories/auth_epository.dart';
import 'dart:io'; // Import File

@lazySingleton
class SignInWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignInWithEmailAndPasswordUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
  ) async {
    return await repository.signInWithEmailAndPassword(email, password);
  }
}

@lazySingleton
class SignUpWithEmailAndPasswordUseCase {
  final AuthRepository repository;

  SignUpWithEmailAndPasswordUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call(
    String email,
    String password,
    String firstName,
    String lastName,
    File? profileImage, // Added profileImage
  ) async {
    return await repository.signUpWithEmailAndPassword(
        email, password, firstName, lastName, profileImage);
  }
}

@lazySingleton
class SignInWithGoogleUseCase {
  final AuthRepository repository;

  SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, UserEntity>> call() async {
    return await repository.signInWithGoogle();
  }
}

@lazySingleton
class SignOutUseCase {
  final AuthRepository repository;

  SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}

@lazySingleton
class GetAuthStateChangesUseCase {
  final AuthRepository repository;

  GetAuthStateChangesUseCase(this.repository);

  Stream<UserEntity?> call() {
    return repository.authStateChanges;
  }
}

@lazySingleton
class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, void>> call(String email) async {
    return await repository.resetPassword(email);
  }
}

// Removed UploadProfileImageUseCase as its logic is embedded in SignUpWithEmailAndPasswordUseCase
