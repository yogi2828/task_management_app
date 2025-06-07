/// lib/features/task/presentation/pages/task_list_page.dart
///
/// The main task list screen. It displays tasks, allows filtering,
/// and provides navigation to create/edit tasks.
/// It interacts with the [TaskBloc] to fetch and manage tasks.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/app/routes/app_router.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/utils/app_styles.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_event.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager_app/features/task/domain/entities/task.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_bloc.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_event.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_state.dart';
import 'package:task_manager_app/features/task/presentation/widgets/task_filter_chips.dart';
import 'package:task_manager_app/features/task/presentation/widgets/task_list_item.dart';
import 'package:intl/intl.dart'; // For date formatting

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    // Listen for auth state changes to get the current user ID
    // This is a simple way to get userId. For more robust apps,
    // consider a dedicated AuthRepository.getCurrentUser() or similar.
    final authState = BlocProvider.of<AuthBloc>(context).state;
    if (authState is AuthAuthenticated) {
      _currentUserId = authState.user.uid;
      BlocProvider.of<TaskBloc>(context).add(LoadTasks(userId: _currentUserId!));
    }
  }

  // Group tasks by date for display
  Map<String, List<TaskEntity>> _groupTasksByDate(List<TaskEntity> tasks) {
    Map<String, List<TaskEntity>> groupedTasks = {};
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = DateTime(now.year, now.month, now.day + 1);

    for (var task in tasks) {
      String dateLabel;
      final taskDate = DateTime(task.dueDate.year, task.dueDate.month, task.dueDate.day);

      if (taskDate.isAtSameMomentAs(today)) {
        dateLabel = 'Today, ${DateFormat.MMMMd().format(task.dueDate)}';
      } else if (taskDate.isAtSameMomentAs(tomorrow)) {
        dateLabel = 'Tomorrow, ${DateFormat.MMMMd().format(task.dueDate)}';
      } else if (taskDate.isAfter(today) && taskDate.isBefore(today.add(const Duration(days: 7)))) {
        dateLabel = 'This week, ${DateFormat.MMMMd().format(task.dueDate)}';
      } else {
        dateLabel = DateFormat.yMMMMd().format(task.dueDate);
      }

      if (!groupedTasks.containsKey(dateLabel)) {
        groupedTasks[dateLabel] = [];
      }
      groupedTasks[dateLabel]!.add(task);
    }
    return groupedTasks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        title: Text(
          'My Tasks',
          style: AppStyles.heading2.copyWith(color: AppColors.textLight),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.textLight),
            onPressed: () {
              // TODO: Implement search functionality
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search not implemented yet.')),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.textLight),
            onPressed: () {
              BlocProvider.of<AuthBloc>(context).add(const AuthLogoutRequested());
              Navigator.of(context).pushReplacementNamed(AppRoutes.login);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Header with current date and 'My Tasks'
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Today, ${DateFormat.MMMMd().format(DateTime.now())}',
                  style: AppStyles.smallText.copyWith(color: AppColors.greyText),
                ),
                Text(
                  'My tasks',
                  style: AppStyles.heading2.copyWith(color: AppColors.textDark),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Filter Chips
          const TaskFilterChips(),
          const SizedBox(height: 10),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (_currentUserId == null) {
                  return const Center(child: Text('Please login to view tasks.'));
                }
                if (state is TaskLoading && state.tasks.isEmpty) {
                  return const Center(child: CircularProgressIndicator(color: AppColors.primaryPurple));
                } else if (state is TaskError) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                } else if (state.tasks.isEmpty) {
                  return const Center(
                    child: Text('No tasks found. Add a new task!', style: AppStyles.bodyText1),
                  );
                } else {
                  final groupedTasks = _groupTasksByDate(state.tasks);
                  final sortedDateKeys = groupedTasks.keys.toList()..sort((a, b) {
                    // Custom sort for date labels (e.g., Today < Tomorrow < This Week < Other Dates)
                    if (a.startsWith('Today')) return -1;
                    if (b.startsWith('Today')) return 1;
                    if (a.startsWith('Tomorrow')) return -1;
                    if (b.startsWith('Tomorrow')) return 1;
                    if (a.startsWith('This week')) return -1;
                    if (b.startsWith('This week')) return 1;
                    // For other dates, rely on the actual date string order (or parse to DateTime for precise sort)
                    return a.compareTo(b);
                  });


                  return ListView.builder(
                    itemCount: sortedDateKeys.length,
                    itemBuilder: (context, index) {
                      final dateLabel = sortedDateKeys[index];
                      final tasksForDate = groupedTasks[dateLabel]!;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 24.0, top: 16.0, bottom: 8.0),
                            child: Text(
                              dateLabel,
                              style: AppStyles.subheading.copyWith(color: AppColors.textDark),
                            ),
                          ),
                          ...tasksForDate.map((task) => TaskListItem(
                                task: task,
                                onEdit: () {
                                  Navigator.of(context).pushNamed(
                                    AppRoutes.editTask,
                                    arguments: task, // Pass the task to the edit page
                                  );
                                },
                              )).toList(),
                        ],
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_currentUserId != null) {
            Navigator.of(context).pushNamed(AppRoutes.createTask, arguments: _currentUserId);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please log in to add tasks.'),
                backgroundColor: AppColors.redError,
              ),
            );
          }
        },
        backgroundColor: AppColors.primaryPurple,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: AppColors.textLight, size: 30),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.white,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.list_alt, color: AppColors.primaryPurple),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.calendar_today, color: AppColors.greyText),
              onPressed: () {
                // TODO: Implement calendar view
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Calendar View not implemented yet.')),
                );
              },
            ),
            const SizedBox(width: 48), // The space for the FAB
            IconButton(
              icon: const Icon(Icons.folder, color: AppColors.greyText),
              onPressed: () {
                // TODO: Implement categories view
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Categories View not implemented yet.')),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings, color: AppColors.greyText),
              onPressed: () {
                // TODO: Implement settings view
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Settings View not implemented yet.')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

