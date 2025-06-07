/// lib/features/task/data/repositories/task_repository_impl.dart
///
/// Implements the [TaskRepository] interface defined in the domain layer.
/// This class coordinates with the [TaskRemoteDataSource] to manage task data
/// and maps [Exception]s from the data source to [Failure]s in the domain.
import 'package:dartz/dartz.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import FirebaseFirestore
import 'package:task_manager_app/utils/constants.dart'; // Import AppConstants
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/core/errors/failures.dart';
import 'package:task_manager_app/core/usecases/usecase.dart'; // For NoType
import 'package:task_manager_app/features/task/data/datasources/task_remote_datasource.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/domain/repositories/task_repository.dart';
import 'package:uuid/uuid.dart'; // For generating unique IDs

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;
  final FirebaseFirestore firestore; // Corrected: Declare the firestore instance here
  final Uuid uuid = const Uuid(); // Instantiate Uuid for ID generation

  TaskRepositoryImpl({required this.remoteDataSource, required this.firestore}); // Corrected: 'firestore' must be a required named parameter

  @override
  Future<Either<Failure, NoType>> createTask(TaskEntity task) async {
    try {
      // Ensure the task has an ID before sending to remote data source
      final taskWithId = task.copyWith(id: task.id.isEmpty ? uuid.v4() : task.id);
      await remoteDataSource.addTask(TaskModel.fromEntity(taskWithId));
      return const Right(NoType());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, NoType>> updateTask(TaskEntity task) async {
    try {
      await remoteDataSource.updateTask(TaskModel.fromEntity(task));
      return const Right(NoType());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, NoType>> deleteTask(String taskId) async {
    try {
      await remoteDataSource.removeTask(taskId);
      return const Right(NoType());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred: $e'));
    }
  }

  @override
  Stream<Either<Failure, List<TaskEntity>>> getTasks(String userId) async* {
    try {
      // The remoteDataSource.getTasksStream handles converting Firestore snapshots to TaskModel.
      // We map these TaskModels back to TaskEntities for the domain layer.
      await for (final taskModels in remoteDataSource.getTasksStream(userId)) {
        final taskEntities = taskModels.map((model) => model as TaskEntity).toList();
        yield Right(taskEntities);
      }
    } on ServerException catch (e) {
      yield Left(ServerFailure(message: e.message));
    } catch (e) {
      yield Left(UnknownFailure(message: 'An unexpected stream error occurred: $e'));
    }
  }

  @override
  Future<Either<Failure, NoType>> toggleTaskCompletion(String taskId, bool isCompleted) async {
    try {
      // Fetch the current task to modify its status
      // Corrected: Use the injected firestore instance
      final querySnapshot = await firestore.collection(AppConstants.tasksCollection).doc(taskId).get();

      if (!querySnapshot.exists) {
        return Left(ServerFailure(message: 'Task with ID $taskId not found.'));
      }

      final TaskModel existingTask = TaskModel.fromFirestore(querySnapshot);
      final updatedTask = existingTask.copyWith(status: TaskStatus.fromBool(isCompleted));

      await remoteDataSource.updateTask(updatedTask);
      return const Right(NoType());
    } on ServerException catch (e) {
      return Left(ServerFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'An unexpected error occurred while toggling task status: $e'));
    }
  }
}

