/// lib/features/auth/data/repositories/auth_repository_impl.dart
///
/// Implements the [AuthRepository] interface defined in the domain layer.
/// This class coordinates with the [AuthRemoteDataSource] to fetch data
/// and maps [Exception]s from the data source to [Failure]s in the domain.
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb_auth; // Alias to avoid conflict with our UserEntity
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart'; // For NoType
import 'package:task_manager_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl({required this.remoteDataSource});

  /// Helper method to map Firebase User to our domain UserEntity
  UserEntity? _mapFirebaseUserToUserEntity(fb_auth.User? firebaseUser) {
    if (firebaseUser == null) {
      return null;
    }
    return UserEntity(uid: firebaseUser.uid, email: firebaseUser.email);
  }

  @override
  Future<Either<Failure, UserEntity>> registerUser(String email, String password) async {
    try {
      final firebaseUser = await remoteDataSource.registerWithEmailAndPassword(email, password);
      return Right(_mapFirebaseUserToUserEntity(firebaseUser)!);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> loginUser(String email, String password) async {
    try {
      final firebaseUser = await remoteDataSource.signInWithEmailAndPassword(email, password);
      return Right(_mapFirebaseUserToUserEntity(firebaseUser)!);
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, NoType>> logoutUser() async {
    try {
      await remoteDataSource.signOut();
      return const Right(NoType());
    } on AuthException catch (e) {
      return Left(AuthFailure(message: e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Stream<UserEntity?> get authStateChanges {
    return remoteDataSource.authStateChanges.map(_mapFirebaseUserToUserEntity);
  }
}

