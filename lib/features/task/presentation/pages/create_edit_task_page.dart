/// lib/features/task/presentation/pages/create_edit_task_page.dart
///
/// A screen for creating a new task or editing an existing one.
/// It takes an optional [TaskEntity] as an argument for editing.
/// It interacts with the [TaskBloc] to dispatch add or update events.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/utils/app_styles.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager_app/features/auth/presentation/widgets/auth_form_field.dart'; // Reusing for consistent styling
import 'package:intl/intl.dart'; // For date formatting
import 'package:uuid/uuid.dart'; // For generating new UUIDs

class CreateEditTaskPage extends StatefulWidget {
  final TaskEntity? task; // Null for create, non-null for edit
  final String? userId; // Required for creating new tasks

  const CreateEditTaskPage({super.key, this.task, this.userId});

  @override
  State<CreateEditTaskPage> createState() => _CreateEditTaskPageState();
}

class _CreateEditTaskPageState extends State<CreateEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime _selectedDueDate = DateTime.now();
  Priority _selectedPriority = Priority.medium;
  bool _isCompleted = false;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      // Populate fields if editing an existing task
      _titleController.text = widget.task!.title;
      _descriptionController.text = widget.task!.description;
      _selectedDueDate = widget.task!.dueDate;
      _selectedPriority = widget.task!.priority;
      _isCompleted = widget.task!.status == TaskStatus.completed;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDueDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)), // Allow past dates for existing tasks
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: AppColors.primaryPurple,
            colorScheme: const ColorScheme.light(primary: AppColors.primaryPurple),
            buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != _selectedDueDate) {
      setState(() {
        _selectedDueDate = picked;
      });
    }
  }

  void _saveTask() {
    if (_formKey.currentState?.validate() ?? false) {
      final String currentUserId;
      if (widget.task != null) {
        // When editing, use the existing task's userId
        currentUserId = widget.task!.userId;
      } else {
        // When creating, use the userId passed from TaskListPage
        currentUserId = (BlocProvider.of<AuthBloc>(context).state as AuthAuthenticated).user.uid;
      }

      TaskEntity task = TaskEntity(
        id: widget.task?.id ?? const Uuid().v4(), // Use existing ID or generate new
        title: _titleController.text.trim(),
        description: _descriptionController.text.trim(),
        dueDate: _selectedDueDate,
        priority: _selectedPriority,
        status: _isCompleted ? TaskStatus.completed : TaskStatus.incomplete,
        userId: currentUserId,
      );

      if (widget.task == null) {
        // Create new task
        BlocProvider.of<TaskBloc>(context).add(AddTask(task: task));
      } else {
        // Update existing task
        BlocProvider.of<TaskBloc>(context).add(UpdateTaskEvent(task: task));
      }
      Navigator.of(context).pop(); // Go back to task list
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isEditing = widget.task != null;
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Edit Task' : 'Create Task',
          style: AppStyles.heading2.copyWith(color: AppColors.textLight),
        ),
        backgroundColor: AppColors.primaryPurple,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.textLight),
      ),
      body: BlocListener<TaskBloc, TaskState>(
        listener: (context, state) {
          if (state is TaskError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ?? 'An unknown error occurred.'),
                backgroundColor: AppColors.redError,
              ),
            );
          }
          // Note: We pop the page directly after save in _saveTask,
          // so explicit success listener for navigation might not be needed here.
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AuthFormField(
                  controller: _titleController,
                  labelText: 'Task Title',
                  hintText: 'e.g., Finish project report',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a task title';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16.0),
                AuthFormField(
                  controller: _descriptionController,
                  labelText: 'Description',
                  hintText: 'Add more details about the task',
                  keyboardType: TextInputType.multiline,
                ),
                const SizedBox(height: 24.0),
                Text('Due Date', style: AppStyles.subheading.copyWith(color: AppColors.textDark)),
                const SizedBox(height: 8.0),
                GestureDetector(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: AppColors.lightGreyBackground,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMd().format(_selectedDueDate),
                          style: AppStyles.bodyText1,
                        ),
                        const Icon(Icons.calendar_today, color: AppColors.greyText),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                Text('Priority', style: AppStyles.subheading.copyWith(color: AppColors.textDark)),
                const SizedBox(height: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreyBackground,
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Priority>(
                      value: _selectedPriority,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down, color: AppColors.greyText),
                      onChanged: (Priority? newValue) {
                        if (newValue != null) {
                          setState(() {
                            _selectedPriority = newValue;
                          });
                        }
                      },
                      items: Priority.values.map((Priority priority) {
                        return DropdownMenuItem<Priority>(
                          value: priority,
                          child: Text(priority.name.toUpperCase(), style: AppStyles.bodyText1),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const SizedBox(height: 24.0),
                if (isEditing) // Only show status toggle if editing
                  Row(
                    children: [
                      Checkbox(
                        value: _isCompleted,
                        onChanged: (bool? newValue) {
                          setState(() {
                            _isCompleted = newValue ?? false;
                          });
                        },
                        activeColor: AppColors.primaryPurple,
                      ),
                      Text('Mark as Completed', style: AppStyles.bodyText1.copyWith(color: AppColors.textDark)),
                    ],
                  ),
                const SizedBox(height: 32.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: BlocProvider.of<TaskBloc>(context).state is TaskLoading
                        ? null
                        : _saveTask,
                    style: AppStyles.primaryButtonStyle,
                    child: BlocProvider.of<TaskBloc>(context).state is TaskLoading
                        ? const CircularProgressIndicator(color: AppColors.textLight)
                        : Text(isEditing ? 'Update Task' : 'Create Task'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

