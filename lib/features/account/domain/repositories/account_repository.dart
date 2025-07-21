// lib/features/account/domain/repositories/account_repository.dart

import 'package:dartz/dartz.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'dart:io';

abstract class AccountRepository {
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  });
}
