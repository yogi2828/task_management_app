/// lib/features/task/domain/usecases/update_task.dart
///
/// Defines the use case for updating an existing task.
/// This class orchestrates the task update process by interacting
/// with the [TaskRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class UpdateTask implements UseCase<NoType, UpdateTaskParams> {
  final TaskRepository repository;

  UpdateTask(this.repository);

  @override
  Future<Either<Failure, NoType>> call(UpdateTaskParams params) async {
    return await repository.updateTask(params.task);
  }
}

/// Parameters required for the [UpdateTask] use case.
class UpdateTaskParams extends Equatable {
  final TaskEntity task;

  const UpdateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}

