/// lib/features/auth/data/datasources/auth_remote_datasource.dart
///
/// Defines the abstract interface for the remote authentication data source.
/// This contract specifies the raw authentication operations with Firebase.
/// It's concerned with how data is retrieved/sent to the remote source,
/// not with business logic.
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRemoteDataSource {
  /// Registers a new user with email and password using Firebase Authentication.
  ///
  /// Throws [AuthException] or [ServerException] on failure.
  Future<User> registerWithEmailAndPassword(String email, String password);

  /// Signs in an existing user with email and password using Firebase Authentication.
  ///
  /// Throws [AuthException] or [ServerException] on failure.
  Future<User> signInWithEmailAndPassword(String email, String password);

  /// Signs out the current user from Firebase Authentication.
  ///
  /// Throws [AuthException] or [ServerException] on failure.
  Future<void> signOut();

  /// Provides a stream of Firebase [User] objects, representing the current
  /// authentication state. Null indicates no user is signed in.
  Stream<User?> get authStateChanges;
}

