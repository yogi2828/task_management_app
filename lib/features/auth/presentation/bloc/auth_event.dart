/// lib/features/auth/presentation/bloc/auth_event.dart
///
/// Defines the events that can be dispatched to the [AuthBloc].
/// These events represent user actions or system events related to authentication.
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => []; // Corrected: Base class must return List<Object?>
}

/// Event dispatched when a user attempts to log in.
class AuthLoginRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthLoginRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event dispatched when a user attempts to register.
class AuthRegisterRequested extends AuthEvent {
  final String email;
  final String password;

  const AuthRegisterRequested({required this.email, required this.password});

  @override
  List<Object?> get props => [email, password];
}

/// Event dispatched when a user requests to log out.
class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();

  @override
  List<Object?> get props => [];
}

/// Event dispatched internally by the BLoC when the authentication
/// state changes (e.g., user logs in, logs out, or app starts).
class AuthUserChanged extends AuthEvent {
  final UserEntity? user;

  const AuthUserChanged(this.user);

  @override
  List<Object?> get props => [user]; // Corrected: This now matches the base class's List<Object?>
}

