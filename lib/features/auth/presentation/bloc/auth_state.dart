/// lib/features/auth/presentation/bloc/auth_state.dart
///
/// Defines the states that the [AuthBloc] can be in.
/// These states represent the current authentication status and any
/// associated data or errors.
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

/// Initial state of the Auth BLoC.
class AuthInitial extends AuthState {}

/// State indicating that an authentication operation is in progress.
class AuthLoading extends AuthState {}

/// State indicating that a user is successfully authenticated.
class AuthAuthenticated extends AuthState {
  final UserEntity user;

  const AuthAuthenticated({required this.user});

  @override
  List<Object> get props => [user];
}

/// State indicating that no user is authenticated.
class AuthUnauthenticated extends AuthState {}

/// State indicating that an authentication operation resulted in an error.
class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object> get props => [message];
}

