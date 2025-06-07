/// lib/features/task/domain/usecases/get_tasks.dart
///
/// Defines the use case for retrieving tasks.
/// This class orchestrates the task retrieval process by interacting
/// with the [TaskRepository] and provides a stream for real-time updates.
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class GetTasks implements StreamUseCase<List<TaskEntity>, GetTasksParams> {
  final TaskRepository repository;

  GetTasks(this.repository);

  @override
  Stream<Either<Failure, List<TaskEntity>>> call(GetTasksParams params) {
    return repository.getTasks(params.userId);
  }
}

/// Parameters required for the [GetTasks] use case.
class GetTasksParams extends Equatable {
  final String userId;

  const GetTasksParams({required this.userId});

  @override
  List<Object> get props => [userId];
}

