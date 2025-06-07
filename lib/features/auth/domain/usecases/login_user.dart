/// lib/features/auth/domain/usecases/login_user.dart
///
/// Defines the use case for user login. This class orchestrates the login
/// process by interacting with the [AuthRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';

class LoginUser implements UseCase<UserEntity, LoginUserParams> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginUserParams params) async {
    return await repository.loginUser(params.email, params.password);
  }
}

/// Parameters required for the [LoginUser] use case.
class LoginUserParams extends Equatable {
  final String email;
  final String password;

  const LoginUserParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

