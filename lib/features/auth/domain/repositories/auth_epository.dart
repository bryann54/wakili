// lib/features/auth/domain/repositories/auth_epository.dart

import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/auth/domain/entities/user_entity.dart';
import 'dart:io'; 

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  );
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
    File? profileImage, 
  );
  Future<Either<Failure, UserEntity>> signInWithGoogle();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, void>> resetPassword(String email);
}
