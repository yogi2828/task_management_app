/// lib/features/task/data/datasources/task_remote_datasource_impl.dart
///
/// Implements the [TaskRemoteDataSource] using Firebase Firestore.
/// This class directly interacts with the FirebaseFirestore package.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_app/utils/constants.dart';
import 'package:task_manager_app/core/errors/exceptions.dart';
import 'package:task_manager_app/features/task/data/datasources/task_remote_datasource.dart';
import 'package:task_manager_app/features/task/data/models/task_model.dart';

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore firestore;

  TaskRemoteDataSourceImpl({required this.firestore});

  @override
  Future<void> addTask(TaskModel task) async {
    try {
      await firestore.collection(AppConstants.tasksCollection).doc(task.id).set(task.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to add task to Firestore');
    } catch (e) {
      throw ServerException(message: 'Unknown error adding task: $e');
    }
  }

  @override
  Future<void> updateTask(TaskModel task) async {
    try {
      await firestore.collection(AppConstants.tasksCollection).doc(task.id).update(task.toFirestore());
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to update task in Firestore');
    } catch (e) {
      throw ServerException(message: 'Unknown error updating task: $e');
    }
  }

  @override
  Future<void> removeTask(String taskId) async {
    try {
      await firestore.collection(AppConstants.tasksCollection).doc(taskId).delete();
    } on FirebaseException catch (e) {
      throw ServerException(message: e.message ?? 'Failed to delete task from Firestore');
    } catch (e) {
      throw ServerException(message: 'Unknown error deleting task: $e');
    }
  }

  @override
  Stream<List<TaskModel>> getTasksStream(String userId) {
    try {
      return firestore
          .collection(AppConstants.tasksCollection)
          .where('userId', isEqualTo: userId)
          // Removed orderBy to avoid index issues. Sorting will be done client-side.
          .snapshots()
          .map((snapshot) {
        return snapshot.docs.map((doc) => TaskModel.fromFirestore(doc)).toList();
      }).handleError((error) {
        // Catch stream errors and rethrow as ServerException
        if (error is FirebaseException) {
          throw ServerException(message: error.message ?? 'Firestore stream error');
        } else {
          throw ServerException(message: 'Unknown stream error: $error');
        }
      });
    } catch (e) {
      throw ServerException(message: 'Failed to establish task stream: $e');
    }
  }
}

