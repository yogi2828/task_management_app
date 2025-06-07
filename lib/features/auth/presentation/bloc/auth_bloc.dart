/// lib/features/auth/presentation/bloc/auth_bloc.dart
///
/// Manages the authentication state of the application.
/// It processes [AuthEvent]s, interacts with authentication use cases,
/// and emits [AuthState]s to update the UI.
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/usecases/get_auth_state_changes.dart';
import 'package:task_manager_app/features/auth/domain/usecases/login_user.dart';
import 'package:task_manager_app/features/auth/domain/usecases/logout_user.dart';
import 'package:task_manager_app/features/auth/domain/usecases/register_user.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUser loginUser;
  final RegisterUser registerUser;
  final LogoutUser logoutUser;
  final GetAuthStateChanges getAuthStateChanges;

  StreamSubscription? _userSubscription; // To listen for auth state changes

  AuthBloc({
    required this.loginUser,
    required this.registerUser,
    required this.logoutUser,
    required this.getAuthStateChanges,
  }) : super(AuthInitial()) {
    // Listen to the stream of authentication state changes as soon as the BLoC is created
    _userSubscription = getAuthStateChanges(const NoParams()).listen((eitherUser) {
      // Dispatch AuthUserChanged event based on the stream's output
      eitherUser.fold(
        (failure) {
          // If the stream itself emits a failure, we might want to handle it,
          // though for authStateChanges, a failure is unlikely unless Firebase itself errors.
          // For now, we'll assume the stream only yields UserEntity? or null.
          add(const AuthUserChanged(null)); // Treat as unauthenticated on stream error
        },
        (user) {
          add(AuthUserChanged(user));
        },
      );
    });

    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthUserChanged>(_onUserChanged);
  }

  Future<void> _onLoginRequested(AuthLoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUser(LoginUserParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        // The _userSubscription will handle emitting AuthAuthenticated
        // based on the underlying Firebase auth state change.
        // We just need to ensure the login call succeeds.
        // If the stream doesn't pick up the change immediately,
        // we can still emit AuthAuthenticated here, but it's redundant
        // if the stream is working correctly.
        // For robustness, we let the stream be the single source of truth.
      },
    );
  }

  Future<void> _onRegisterRequested(AuthRegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await registerUser(RegisterUserParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (user) {
        // Similar to login, let the _userSubscription handle the state change.
      },
    );
  }

  Future<void> _onLogoutRequested(AuthLogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await logoutUser(const NoParams());
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (_) {
        // Similar to login/register, let the _userSubscription handle the state change.
      },
    );
  }

  void _onUserChanged(AuthUserChanged event, Emitter<AuthState> emit) {
    if (event.user != null) {
      emit(AuthAuthenticated(user: event.user!));
    } else {
      emit(AuthUnauthenticated());
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel(); // Cancel subscription when BLoC is closed
    return super.close();
  }
}

