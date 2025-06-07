/// lib/features/task/data/models/task_model.dart
///
/// Defines the [TaskModel] which is a data-specific representation of [TaskEntity].
/// It includes methods for serializing to and deserializing from JSON,
/// suitable for storage in Firebase Firestore.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';

class TaskModel extends TaskEntity {
  const TaskModel({
    required super.id,
    required super.title,
    super.description,
    required super.dueDate,
    super.priority,
    super.status,
    required super.userId,
  });

  /// Factory constructor to create a [TaskModel] from a Firestore document snapshot.
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] as String,
      description: data['description'] as String,
      dueDate: (data['dueDate'] as Timestamp).toDate(),
      priority: Priority.fromString(data['priority'] as String),
      status: TaskStatus.fromBool(data['isCompleted'] as bool),
      userId: data['userId'] as String,
    );
  }

  /// Converts this [TaskModel] instance into a JSON-compatible map
  /// for storage in Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate), // Store as Firestore Timestamp
      'priority': priority.name, // Store enum name as string
      'isCompleted': status.toBool(), // Store boolean for status
      'userId': userId,
    };
  }

  /// Creates a [TaskModel] from a [TaskEntity] to allow for easy conversion
  /// when interacting with the domain layer.
  factory TaskModel.fromEntity(TaskEntity entity) {
    return TaskModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      dueDate: entity.dueDate,
      priority: entity.priority,
      status: entity.status,
      userId: entity.userId,
    );
  }

  /// Overrides copyWith to return TaskModel, maintaining type consistency.
  @override
  TaskModel copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    TaskStatus? status,
    String? userId,
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }
}

