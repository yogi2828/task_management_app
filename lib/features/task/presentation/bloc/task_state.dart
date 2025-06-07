/// lib/features/task/presentation/bloc/task_state.dart
///
/// Defines the states that the [TaskBloc] can be in.
/// These states represent the current task list, filters, and any
/// associated loading or error conditions.
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';

abstract class TaskState extends Equatable {
  final List<TaskEntity> tasks;
  final Priority? currentPriorityFilter;
  final TaskStatus? currentStatusFilter;
  final String? errorMessage;

  const TaskState({
    this.tasks = const [],
    this.currentPriorityFilter,
    this.currentStatusFilter,
    this.errorMessage,
  });

  @override
  List<Object?> get props => [tasks, currentPriorityFilter, currentStatusFilter, errorMessage];
}

/// Initial state of the Task BLoC.
class TaskInitial extends TaskState {}

/// State indicating that tasks are currently being loaded or an operation is in progress.
class TaskLoading extends TaskState {
  const TaskLoading({
    super.tasks,
    super.currentPriorityFilter,
    super.currentStatusFilter,
  });
}

/// State indicating that tasks have been successfully loaded.
class TaskLoaded extends TaskState {
  const TaskLoaded({
    required super.tasks,
    super.currentPriorityFilter,
    super.currentStatusFilter,
  });
}

/// State indicating that an error occurred during a task operation.
class TaskError extends TaskState {
  const TaskError({
    required super.errorMessage,
    super.tasks,
    super.currentPriorityFilter,
    super.currentStatusFilter,
  });
}

