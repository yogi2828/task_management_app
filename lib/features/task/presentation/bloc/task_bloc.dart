/// lib/features/task/presentation/bloc/task_bloc.dart
///
/// Manages the task list state of the application.
/// It processes [TaskEvent]s, interacts with task use cases,
/// and emits [TaskState]s to update the UI.
import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/domain/usecases/create_task.dart';
import 'package:task_manager_app/features/task/domain/usecases/delete_task.dart';
import 'package:task_manager_app/features/task/domain/usecases/get_tasks.dart';
import 'package:task_manager_app/features/task/domain/usecases/toggle_task_completion.dart';
import 'package:task_manager_app/features/task/domain/usecases/update_task.dart';
import 'task_event.dart';
import 'task_state.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final CreateTask createTask;
  final DeleteTask deleteTask;
  final GetTasks getTasks;
  final UpdateTask updateTask;
  final ToggleTaskCompletion toggleTaskCompletion;

  StreamSubscription? _tasksSubscription;
  String? _currentUserId; // To keep track of the user whose tasks are being loaded

  TaskBloc({
    required this.createTask,
    required this.deleteTask,
    required this.getTasks,
    required this.updateTask,
    required this.toggleTaskCompletion,
  }) : super(TaskInitial()) {
    on<LoadTasks>(_onLoadTasks);
    on<AddTask>(_onAddTask);
    on<UpdateTaskEvent>(_onUpdateTask);
    on<DeleteTaskEvent>(_onDeleteTask);
    on<ToggleTaskStatusEvent>(_onToggleTaskStatus);
    on<FilterTasksByPriority>(_onFilterTasksByPriority);
    on<FilterTasksByStatus>(_onFilterTasksByStatus);
    on<TasksUpdated>(_onTasksUpdated);
  }

  /// Disposes of the tasks subscription when the BLoC is closed.
  @override
  Future<void> close() {
    _tasksSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoadTasks(LoadTasks event, Emitter<TaskState> emit) async {
    _currentUserId = event.userId; // Store the user ID
    emit(TaskLoading(
      tasks: state.tasks, // Keep existing tasks while loading
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));

    // Cancel existing subscription if any
    await _tasksSubscription?.cancel();

    // Start a new subscription for real-time task updates
    _tasksSubscription = getTasks(GetTasksParams(userId: event.userId)).listen(
      (eitherTasks) {
        eitherTasks.fold(
          (failure) {
            addError(failure, StackTrace.current); // Propagate failure to onError
            emit(TaskError(
              errorMessage: failure.message,
              tasks: state.tasks,
              currentPriorityFilter: state.currentPriorityFilter,
              currentStatusFilter: state.currentStatusFilter,
            ));
          },
          (tasks) {
            add(TasksUpdated(tasks)); // Dispatch internal event when tasks update
          },
        );
      },
      onError: (error, stackTrace) {
        // This catch-all error handling for the stream
        emit(TaskError(
          errorMessage: error.toString(),
          tasks: state.tasks,
          currentPriorityFilter: state.currentPriorityFilter,
          currentStatusFilter: state.currentStatusFilter,
        ));
      },
    );
  }

  void _onTasksUpdated(TasksUpdated event, Emitter<TaskState> emit) {
    // Apply filters and sorting when tasks are updated from the stream
    List<TaskEntity> filteredTasks = _applyFiltersAndSort(
      event.tasks,
      state.currentPriorityFilter,
      state.currentStatusFilter,
    );
    emit(TaskLoaded(
      tasks: filteredTasks,
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));
  }

  Future<void> _onAddTask(AddTask event, Emitter<TaskState> emit) async {
    emit(TaskLoading(
      tasks: state.tasks,
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));
    final result = await createTask(CreateTaskParams(task: event.task));
    result.fold(
      (failure) => emit(TaskError(
        errorMessage: failure.message,
        tasks: state.tasks,
        currentPriorityFilter: state.currentPriorityFilter,
        currentStatusFilter: state.currentStatusFilter,
      )),
      (_) {
        // No explicit state change needed here, as the stream will emit TasksUpdated.
        // If there's an immediate need for feedback before stream update,
        // a TaskAdded/Success state could be added.
      },
    );
  }

  Future<void> _onUpdateTask(UpdateTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading(
      tasks: state.tasks,
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));
    final result = await updateTask(UpdateTaskParams(task: event.task));
    result.fold(
      (failure) => emit(TaskError(
        errorMessage: failure.message,
        tasks: state.tasks,
        currentPriorityFilter: state.currentPriorityFilter,
        currentStatusFilter: state.currentStatusFilter,
      )),
      (_) {
        // No explicit state change needed here, as the stream will emit TasksUpdated.
      },
    );
  }

  Future<void> _onDeleteTask(DeleteTaskEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading(
      tasks: state.tasks,
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));
    final result = await deleteTask(DeleteTaskParams(taskId: event.taskId));
    result.fold(
      (failure) => emit(TaskError(
        errorMessage: failure.message,
        tasks: state.tasks,
        currentPriorityFilter: state.currentPriorityFilter,
        currentStatusFilter: state.currentStatusFilter,
      )),
      (_) {
        // No explicit state change needed here, as the stream will emit TasksUpdated.
      },
    );
  }

  Future<void> _onToggleTaskStatus(ToggleTaskStatusEvent event, Emitter<TaskState> emit) async {
    emit(TaskLoading(
      tasks: state.tasks,
      currentPriorityFilter: state.currentPriorityFilter,
      currentStatusFilter: state.currentStatusFilter,
    ));
    final result = await toggleTaskCompletion(
      ToggleTaskCompletionParams(taskId: event.taskId, isCompleted: event.isCompleted),
    );
    result.fold(
      (failure) => emit(TaskError(
        errorMessage: failure.message,
        tasks: state.tasks,
        currentPriorityFilter: state.currentPriorityFilter,
        currentStatusFilter: state.currentStatusFilter,
      )),
      (_) {
        // No explicit state change needed here, as the stream will emit TasksUpdated.
      },
    );
  }

  void _onFilterTasksByPriority(FilterTasksByPriority event, Emitter<TaskState> emit) {
    // Only update filter state and re-apply filters if the underlying tasks are loaded
    if (state is TaskLoaded) {
      final List<TaskEntity> currentTasks = (state as TaskLoaded).tasks;
      final List<TaskEntity> filteredTasks = _applyFiltersAndSort(
        currentTasks,
        event.priority,
        state.currentStatusFilter,
      );
      emit(TaskLoaded(
        tasks: filteredTasks,
        currentPriorityFilter: event.priority,
        currentStatusFilter: state.currentStatusFilter,
      ));
    } else {
      // If not loaded, just update the filter and keep current state
      emit(state.copyWith(currentPriorityFilter: event.priority));
    }
  }

  void _onFilterTasksByStatus(FilterTasksByStatus event, Emitter<TaskState> emit) {
    // Only update filter state and re-apply filters if the underlying tasks are loaded
    if (state is TaskLoaded) {
      final List<TaskEntity> currentTasks = (state as TaskLoaded).tasks;
      final List<TaskEntity> filteredTasks = _applyFiltersAndSort(
        currentTasks,
        state.currentPriorityFilter,
        event.status,
      );
      emit(TaskLoaded(
        tasks: filteredTasks,
        currentPriorityFilter: state.currentPriorityFilter,
        currentStatusFilter: event.status,
      ));
    } else {
      // If not loaded, just update the filter and keep current state
      emit(state.copyWith(currentStatusFilter: event.status));
    }
  }

  /// Helper method to apply current filters and sort tasks.
  List<TaskEntity> _applyFiltersAndSort(
    List<TaskEntity> tasks,
    Priority? priorityFilter,
    TaskStatus? statusFilter,
  ) {
    List<TaskEntity> filtered = List.from(tasks); // Create a mutable copy

    if (priorityFilter != null) {
      filtered = filtered.where((task) => task.priority == priorityFilter).toList();
    }

    if (statusFilter != null) {
      filtered = filtered.where((task) => task.status == statusFilter).toList();
    }

    // Sort by due date (earliest to latest)
    filtered.sort((a, b) => a.dueDate.compareTo(b.dueDate));

    return filtered;
  }
}

// Extension to allow copyWith on TaskState
extension TaskStateCopyWith on TaskState {
  TaskState copyWith({
    List<TaskEntity>? tasks,
    Priority? currentPriorityFilter,
    TaskStatus? currentStatusFilter,
    String? errorMessage,
  }) {
    // Determine the exact type of the current state
    if (this is TaskInitial) {
      return TaskInitial();
    } else if (this is TaskLoading) {
      return TaskLoading(
        tasks: tasks ?? this.tasks,
        currentPriorityFilter: currentPriorityFilter ?? this.currentPriorityFilter,
        currentStatusFilter: currentStatusFilter ?? this.currentStatusFilter,
      );
    } else if (this is TaskLoaded) {
      return TaskLoaded(
        tasks: tasks ?? this.tasks,
        currentPriorityFilter: currentPriorityFilter ?? this.currentPriorityFilter,
        currentStatusFilter: currentStatusFilter ?? this.currentStatusFilter,
      );
    } else if (this is TaskError) {
      return TaskError(
        errorMessage: errorMessage ?? (this as TaskError).errorMessage,
        tasks: tasks ?? this.tasks,
        currentPriorityFilter: currentPriorityFilter ?? this.currentPriorityFilter,
        currentStatusFilter: currentStatusFilter ?? this.currentStatusFilter,
      );
    }
    return this; // Should not happen
  }
}

