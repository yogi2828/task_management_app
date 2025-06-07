/// lib/features/task/data/datasources/task_remote_datasource.dart
///
/// Defines the abstract interface for the remote task data source.
/// This contract specifies the raw CRUD and real-time operations with Firestore.
/// It's concerned with how data is retrieved/sent to the remote source,
/// not with business logic or domain entities.
import 'package:task_manager_app/features/task/data/models/task_model.dart';

abstract class TaskRemoteDataSource {
  /// Adds a new task to Firestore.
  /// Throws [ServerException] on failure.
  Future<void> addTask(TaskModel task);

  /// Updates an existing task in Firestore.
  /// Throws [ServerException] on failure.
  Future<void> updateTask(TaskModel task);

  /// Deletes a task by its ID from Firestore.
  /// Throws [ServerException] on failure.
  Future<void> removeTask(String taskId);

  /// Provides a stream of lists of [TaskModel] for a given [userId].
  /// This stream allows for real-time updates to the task list from Firestore.
  /// Throws [ServerException] on stream errors.
  Stream<List<TaskModel>> getTasksStream(String userId);
}

