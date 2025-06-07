/// lib/features/task/presentation/widgets/task_list_item.dart
///
/// A reusable widget to display a single task item in the list.
/// It includes options for toggling completion and swipe actions.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/utils/app_styles.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_event.dart';
import 'package:intl/intl.dart';

class TaskListItem extends StatelessWidget {
  final TaskEntity task;
  final VoidCallback onEdit;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.id), // Unique key for Dismissible
      direction: DismissDirection.endToStart, // Swipe from right to left
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        color: AppColors.redError,
        child: const Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      confirmDismiss: (direction) async {
        // Implement a confirmation dialog if needed
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Confirm Deletion'),
              content: const Text('Are you sure you want to delete this task?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('Delete', style: TextStyle(color: AppColors.redError)),
                ),
              ],
            );
          },
        );
      },
      onDismissed: (direction) {
        // Dispatch delete event when dismissed
        BlocProvider.of<TaskBloc>(context).add(DeleteTaskEvent(taskId: task.id));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Task "${task.title}" deleted.'),
            backgroundColor: AppColors.primaryPurple,
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 1,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Checkbox(
                value: task.status == TaskStatus.completed,
                onChanged: (bool? newValue) {
                  if (newValue != null) {
                    BlocProvider.of<TaskBloc>(context).add(
                      ToggleTaskStatusEvent(taskId: task.id, isCompleted: newValue),
                    );
                  }
                },
                activeColor: AppColors.primaryPurple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: AppStyles.bodyText1.copyWith(
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.status == TaskStatus.completed
                            ? AppColors.greyText
                            : AppColors.textDark,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${DateFormat.yMMMd().format(task.dueDate)} - ${task.description}',
                      style: AppStyles.smallText.copyWith(
                        decoration: task.status == TaskStatus.completed
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                        color: task.status == TaskStatus.completed
                            ? AppColors.greyText
                            : AppColors.greyText,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              GestureDetector(
                onTap: onEdit,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getPriorityColor(task.priority).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: AppStyles.smallText.copyWith(
                      color: _getPriorityColor(task.priority),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return AppColors.priorityLow;
      case Priority.medium:
        return AppColors.priorityMedium;
      case Priority.high:
        return AppColors.priorityHigh;
    }
  }
}

