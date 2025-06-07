/// lib/features/task/presentation/widgets/task_filter_chips.dart
///
/// A widget for displaying filter chips for task priority and status.
/// It dispatches events to the [TaskBloc] when a filter is selected.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_state.dart';

class TaskFilterChips extends StatelessWidget {
  const TaskFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TaskBloc, TaskState>(
      builder: (context, state) {
        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              // Priority Filters
              _buildFilterChip(
                context,
                label: 'All Priorities',
                isSelected: state.currentPriorityFilter == null,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByPriority(priority: null)),
              ),
              _buildFilterChip(
                context,
                label: 'High',
                isSelected: state.currentPriorityFilter == Priority.high,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByPriority(priority: Priority.high)),
                color: AppColors.priorityHigh,
              ),
              _buildFilterChip(
                context,
                label: 'Medium',
                isSelected: state.currentPriorityFilter == Priority.medium,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByPriority(priority: Priority.medium)),
                color: AppColors.priorityMedium,
              ),
              _buildFilterChip(
                context,
                label: 'Low',
                isSelected: state.currentPriorityFilter == Priority.low,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByPriority(priority: Priority.low)),
                color: AppColors.priorityLow,
              ),
              const SizedBox(width: 20), // Separator

              // Status Filters
              _buildFilterChip(
                context,
                label: 'All Status',
                isSelected: state.currentStatusFilter == null,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByStatus(status: null)),
              ),
              _buildFilterChip(
                context,
                label: 'Incomplete',
                isSelected: state.currentStatusFilter == TaskStatus.incomplete,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByStatus(status: TaskStatus.incomplete)),
              ),
              _buildFilterChip(
                context,
                label: 'Completed',
                isSelected: state.currentStatusFilter == TaskStatus.completed,
                onSelected: (_) => BlocProvider.of<TaskBloc>(context).add(const FilterTasksByStatus(status: TaskStatus.completed)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required Function(bool) onSelected,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: FilterChip(
        label: Text(label),
        labelStyle: TextStyle(
          color: isSelected ? AppColors.textLight : AppColors.textDark,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        selected: isSelected,
        onSelected: onSelected,
        checkmarkColor: AppColors.textLight,
        selectedColor: color ?? AppColors.primaryPurple,
        backgroundColor: AppColors.lightGreyBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: isSelected ? BorderSide.none : const BorderSide(color: AppColors.greyText, width: 0.5),
        ),
      ),
    );
  }
}

