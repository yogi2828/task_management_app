/// lib/features/task/domain/usecases/toggle_task_completion.dart
///
/// Defines the use case for toggling a task's completion status.
/// This class orchestrates the update by interacting with the [TaskRepository].
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';

class ToggleTaskCompletion implements UseCase<NoType, ToggleTaskCompletionParams> {
  final TaskRepository repository;

  ToggleTaskCompletion(this.repository);

  @override
  Future<Either<Failure, NoType>> call(ToggleTaskCompletionParams params) async {
    return await repository.toggleTaskCompletion(params.taskId, params.isCompleted);
  }
}

/// Parameters required for the [ToggleTaskCompletion] use case.
class ToggleTaskCompletionParams extends Equatable {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskCompletionParams({required this.taskId, required this.isCompleted});

  @override
  List<Object> get props => [taskId, isCompleted];
}

