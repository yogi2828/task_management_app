/// lib/features/task/domain/usecases/create_task.dart
///
/// Defines the use case for creating a new task.
/// This class orchestrates the task creation process by interacting
/// with the [TaskRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class CreateTask implements UseCase<NoType, CreateTaskParams> {
  final TaskRepository repository;

  CreateTask(this.repository);

  @override
  Future<Either<Failure, NoType>> call(CreateTaskParams params) async {
    return await repository.createTask(params.task);
  }
}

/// Parameters required for the [CreateTask] use case.
class CreateTaskParams extends Equatable {
  final TaskEntity task;

  const CreateTaskParams({required this.task});

  @override
  List<Object> get props => [task];
}

