/// lib/features/task/domain/repositories/task_repository.dart
///
/// Defines the abstract interface for the task repository.
/// This contract specifies the CRUD operations and real-time task retrieval
/// available to the domain layer, hiding underlying data source details.
import 'package:dartz/dartz.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart'; // For NoType
import 'package:task_manager_app/features/task/domain/entities/task.dart';

abstract class TaskRepository {
  /// Creates a new [TaskEntity] in the data source.
  ///
  /// Returns [Right<NoType>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, NoType>> createTask(TaskEntity task);

  /// Updates an existing [TaskEntity] in the data source.
  ///
  /// Returns [Right<NoType>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, NoType>> updateTask(TaskEntity task);

  /// Deletes a task by its [taskId] from the data source.
  ///
  /// Returns [Right<NoType>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, NoType>> deleteTask(String taskId);

  /// Provides a stream of lists of [TaskEntity] for a given [userId].
  /// This stream is used for real-time updates to the task list.
  ///
  /// Returns [Right<List<TaskEntity>>] on success, or [Left<Failure>] on failure
  /// within the stream.
  Stream<Either<Failure, List<TaskEntity>>> getTasks(String userId);

  /// Toggles the completion status of a task by its [taskId].
  ///
  /// Returns [Right<NoType>] on success, or [Left<Failure>] on failure.
  Future<Either<Failure, NoType>> toggleTaskCompletion(String taskId, bool isCompleted);
}

