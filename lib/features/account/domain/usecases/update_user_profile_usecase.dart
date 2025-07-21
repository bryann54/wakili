// lib/features/account/domain/usecases/update_user_profile_usecase.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/account/domain/repositories/account_repository.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'dart:io';

@injectable
class UpdateUserProfileUseCase {
  final AccountRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<Either<Failure, UserModel>> call({
    required String firstName,
    required String lastName,
    File? profileImage,
  }) {
    return repository.updateUserProfile(
      firstName: firstName,
      lastName: lastName,
      profileImage: profileImage,
    );
  }
}
