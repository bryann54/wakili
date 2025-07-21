// lib/features/account/data/repositories/account_repository_impl.dart

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/account/data/datasources/account_remote_datasource.dart';
import 'package:wakili/features/account/domain/repositories/account_repository.dart';
import 'package:wakili/features/auth/data/models/user_model.dart';
import 'dart:io';

@LazySingleton(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final AccountRemoteDataSource remoteDataSource;

  AccountRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, UserModel>> updateUserProfile({
    required String firstName,
    required String lastName,
    File? profileImage,
  }) async {
    try {
      final userModel = await remoteDataSource.updateUserProfile(
        firstName: firstName,
        lastName: lastName,
        profileImage: profileImage,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(message: e.message ?? 'Failed to update profile.'));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
