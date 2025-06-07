/// lib/features/auth/data/datasources/auth_remote_datasource_impl.dart
///
/// Implements the [AuthRemoteDataSource] using Firebase Authentication.
/// This class directly interacts with the FirebaseAuth package.
import 'package:firebase_auth/firebase_auth.dart';
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/features/auth/data/datasources/auth_remote_datasource.dart';

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final FirebaseAuth auth;

  AuthRemoteDataSourceImpl({required this.auth});

  @override
  Future<User> registerWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return userCredential.user!;
      } else {
        throw const AuthException(message: 'Registration failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      // Map Firebase specific errors to our custom AuthException messages
      String message;
      switch (e.code) {
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          message = 'An account already exists for that email.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'operation-not-allowed':
          message = 'Email & Password accounts are not enabled.';
          break;
        default:
          message = 'An unexpected Firebase authentication error occurred: ${e.message}';
          break;
      }
      throw AuthException(message: message);
    } catch (e) {
      // Catch any other unexpected errors
      throw ServerException(message: 'An unknown error occurred during registration: $e');
    }
  }

  @override
  Future<User> signInWithEmailAndPassword(String email, String password) async {
    try {
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        return userCredential.user!;
      } else {
        throw const AuthException(message: 'Login failed: User is null');
      }
    } on FirebaseAuthException catch (e) {
      // Map Firebase specific errors to our custom AuthException messages
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided for that user.';
          break;
        case 'invalid-email':
          message = 'The email address is not valid.';
          break;
        case 'user-disabled':
          message = 'This user account has been disabled.';
          break;
        default:
          message = 'An unexpected Firebase authentication error occurred: ${e.message}';
          break;
      }
      throw AuthException(message: message);
    } catch (e) {
      // Catch any other unexpected errors
      throw ServerException(message: 'An unknown error occurred during login: $e');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await auth.signOut();
    } on FirebaseAuthException catch (e) {
      String message = 'Failed to sign out: ${e.message}';
      throw AuthException(message: message);
    } catch (e) {
      throw ServerException(message: 'An unknown error occurred during sign out: $e');
    }
  }

  @override
  Stream<User?> get authStateChanges {
    return auth.authStateChanges();
  }
}

