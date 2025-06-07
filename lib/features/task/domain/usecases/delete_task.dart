/// lib/features/task/domain/usecases/delete_task.dart
///
/// Defines the use case for deleting a task.
/// This class orchestrates the task deletion process by interacting
/// with the [TaskRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class DeleteTask implements UseCase<NoType, DeleteTaskParams> {
  final TaskRepository repository;

  DeleteTask(this.repository);

  @override
  Future<Either<Failure, NoType>> call(DeleteTaskParams params) async {
    return await repository.deleteTask(params.taskId);
  }
}

/// Parameters required for the [DeleteTask] use case.
class DeleteTaskParams extends Equatable {
  final String taskId;

  const DeleteTaskParams({required this.taskId});

  @override
  List<Object> get props => [taskId];
}

