import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';
import 'package:wakili/core/errors/exceptions.dart';
import 'package:wakili/core/errors/failures.dart';
import 'package:wakili/features/auth/data/datasources/auth_remoteDataSource.dart';
import 'package:wakili/features/auth/domain/entities/user_entity.dart';
import 'package:wakili/features/auth/domain/repositories/auth_epository.dart';

@LazySingleton(as: AuthRepository)
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges;
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final userModel = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message:
              e.message ?? 'An unknown server error occurred during sign-in.'));
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmailAndPassword(
    String email,
    String password,
    String firstName,
    String lastName,
  ) async {
    try {
      final userModel = await remoteDataSource.signUpWithEmailAndPassword(
        email,
        password,
        firstName,
        lastName,
      );
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message:
              e.message ?? 'An unknown server error occurred during sign-up.'));
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final userModel = await remoteDataSource.signInWithGoogle();
      return Right(userModel);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message ??
              'An unknown server error occurred during Google sign-in.'));
    } on ClientException catch (e) {
      return Left(ClientFailure(message: e.message));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message ??
              'An unknown server error occurred during sign-out.'));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await remoteDataSource.resetPassword(email);
      return const Right(unit);
    } on ServerException catch (e) {
      return Left(ServerFailure(
          message: e.message ??
              'An unknown server error occurred during password reset.'));
    } catch (e) {
      return Left(GeneralFailure(message: e.toString()));
    }
  }
}
