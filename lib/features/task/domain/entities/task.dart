/// lib/features/task/domain/entities/task.dart
///
/// Defines the Task entity for the task management domain.
/// This entity represents the core properties of a task in our application,
/// independent of how the data is stored or presented.
import 'package:equatable/equatable.dart';

/// Enum for task priority levels.
enum Priority {
  low,
  medium,
  high;

  // Helper to convert string to Priority enum
  static Priority fromString(String value) {
    switch (value.toLowerCase()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        return Priority.medium; // Default to medium if unknown
    }
  }
}

/// Enum for task completion status.
enum TaskStatus {
  completed,
  incomplete;

  // Helper to convert boolean to TaskStatus enum
  static TaskStatus fromBool(bool isCompleted) {
    return isCompleted ? TaskStatus.completed : TaskStatus.incomplete;
  }

  // Helper to convert TaskStatus enum to boolean
  bool toBool() {
    return this == TaskStatus.completed;
  }
}

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final Priority priority;
  final TaskStatus status;
  final String userId; // To link tasks to specific users

  const TaskEntity({
    required this.id,
    required this.title,
    this.description = '',
    required this.dueDate,
    this.priority = Priority.medium,
    this.status = TaskStatus.incomplete,
    required this.userId,
  });

  /// Creates a new [TaskEntity] instance with updated properties.
  /// This is used for immutability, returning a new object instead of modifying the existing one.
  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    Priority? priority,
    TaskStatus? status,
    String? userId,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      userId: userId ?? this.userId,
    );
  }

  @override
  List<Object?> get props => [id, title, description, dueDate, priority, status, userId];
}

