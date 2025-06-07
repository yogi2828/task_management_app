/// lib/features/auth/domain/repositories/auth_repository.dart
///
/// Defines the abstract interface for the authentication repository.
/// This contract specifies the authentication operations available to the
/// domain layer, hiding the underlying data source implementation details.
import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  /// Attempts to register a new user with the given [email] and [password].
  ///
  /// Returns [Right<UserEntity>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, UserEntity>> registerUser(String email, String password);

  /// Attempts to log in an existing user with the given [email] and [password].
  ///
  /// Returns [Right<UserEntity>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, UserEntity>> loginUser(String email, String password);

  /// Logs out the currently authenticated user.
  ///
  /// Returns [Right<NoType>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, NoType>> logoutUser();

  /// Provides a stream of [UserEntity] or `null` whenever the authentication
  /// state changes (e.g., user logs in, logs out).
  ///
  /// This stream is used by the presentation layer to react to auth state changes.
  Stream<UserEntity?> get authStateChanges;
}

