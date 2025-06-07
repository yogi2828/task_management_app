/// lib/features/auth/domain/usecases/get_auth_state_changes.dart
///
/// Defines the use case for observing authentication state changes.
/// This stream-based use case allows the presentation layer to react in
/// real-time to user login/logout events.
import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/auth/domain/entities/user.dart';
import 'package:task_manager_app/features/auth/domain/repositories/auth_repository.dart';

class GetAuthStateChanges implements StreamUseCase<UserEntity?, NoParams> {
  final AuthRepository repository;

  GetAuthStateChanges(this.repository);

  @override
  Stream<Either<Failure, UserEntity?>> call(NoParams params) async* {
    // The repository's authStateChanges stream already handles
    // potential failures internally and maps to UserEntity? or null.
    // For consistency with other use cases, we wrap it in an Either.
    await for (final user in repository.authStateChanges) {
      if (user != null) {
        yield Right(user);
      } else {
        yield const Right(null); // No user authenticated
      }
    }
  }
}

