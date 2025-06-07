/// lib/features/task/presentation/bloc/task_event.dart
///
/// Defines the events that can be dispatched to the [TaskBloc].
/// These events represent user actions or system events related to task management.
import 'package:equatable/equatable.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';

abstract class TaskEvent extends Equatable {
  const TaskEvent();

  @override
  List<Object?> get props => []; // Corrected: Base class must return List<Object?>
}

/// Event dispatched to load tasks for a specific user.
class LoadTasks extends TaskEvent {
  final String userId;

  const LoadTasks({required this.userId});

  @override
  List<Object?> get props => [userId];
}

/// Event dispatched to add a new task.
class AddTask extends TaskEvent {
  final TaskEntity task;

  const AddTask({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event dispatched to update an existing task.
class UpdateTaskEvent extends TaskEvent {
  final TaskEntity task;

  const UpdateTaskEvent({required this.task});

  @override
  List<Object?> get props => [task];
}

/// Event dispatched to delete a task.
class DeleteTaskEvent extends TaskEvent {
  final String taskId;

  const DeleteTaskEvent({required this.taskId});

  @override
  List<Object?> get props => [taskId];
}

/// Event dispatched to toggle a task's completion status.
class ToggleTaskStatusEvent extends TaskEvent {
  final String taskId;
  final bool isCompleted;

  const ToggleTaskStatusEvent({required this.taskId, required this.isCompleted});

  @override
  List<Object?> get props => [taskId, isCompleted];
}

/// Event dispatched to filter tasks by priority.
class FilterTasksByPriority extends TaskEvent {
  final Priority? priority; // Null means no priority filter

  const FilterTasksByPriority({this.priority});

  @override
  List<Object?> get props => [priority]; // Corrected: This now matches the base class's List<Object?>
}

/// Event dispatched to filter tasks by status (completed/incomplete).
class FilterTasksByStatus extends TaskEvent {
  final TaskStatus? status; // Null means no status filter

  const FilterTasksByStatus({this.status});

  @override
  List<Object?> get props => [status]; // Corrected: This now matches the base class's List<Object?>
}

/// Internal event dispatched when the underlying task stream emits new data.
class TasksUpdated extends TaskEvent {
  final List<TaskEntity> tasks;

  const TasksUpdated(this.tasks);

  @override
  List<Object?> get props => [tasks];
}

