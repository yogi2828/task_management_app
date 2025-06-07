/// lib/features/auth/domain/usecases/register_user.dart
///
/// Defines the use case for user registration. This class orchestrates the
/// registration process by interacting with the [AuthRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';

class RegisterUser implements UseCase<UserEntity, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await repository.registerUser(params.email, params.password);
  }
}

/// Parameters required for the [RegisterUser] use case.
class RegisterUserParams extends Equatable {
  final String email;
  final String password;

  const RegisterUserParams({required this.email, required this.password});

  @override
  List<Object> get props => [email, password];
}

