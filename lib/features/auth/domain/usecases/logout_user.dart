/// lib/features/auth/domain/usecases/logout_user.dart
///
/// Defines the use case for user logout. This class handles the logout
/// process by interacting with the [AuthRepository].
import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';

class LogoutUser implements UseCase<NoType, NoParams> {
  final AuthRepository repository;

  LogoutUser(this.repository);

  @override
  Future<Either<Failure, NoType>> call(NoParams params) async {
    return await repository.logoutUser();
  }
}

