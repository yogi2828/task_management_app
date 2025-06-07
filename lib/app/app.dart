/// lib/app/app.dart
///
/// The root widget of the application. It sets up Firebase initialization,
/// dependency injection, and defines the application's routing and theme.
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_manager_app/utils/app_colors.dart';
import 'package:task_manager_app/di/injection_container.dart' as di;
import 'package:task_manager_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:task_manager_app/features/auth/presentation/bloc/auth_state.dart';
import 'package:task_manager_app/features/auth/presentation/pages/login_page.dart';
import 'package:task_manager_app/utils/app_styles.dart';
import 'routes/app_router.dart';
import 'package:task_manager_app/features/auth/presentation/pages/registration_page.dart';
import 'package:task_manager_app/features/task/presentation/bloc/task_bloc.dart'; // Import TaskBloc
import 'package:task_manager_app/features/task/presentation/pages/task_list_page.dart';
import 'package:task_manager_app/features/task/presentation/pages/create_edit_task_page.dart'; // Import CreateEditTaskPage
import 'package:task_manager_app/features/task/domain/entities/task.dart'; // Import TaskEntity for route arguments

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    super.initState();
    // Initialize GetIt dependencies here
    di.init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (_) => di.sl<AuthBloc>(),
        ),
        BlocProvider<TaskBloc>( // Add TaskBloc Provider
          create: (_) => di.sl<TaskBloc>(),
        ),
      ],
      child: MaterialApp(
        title: 'Gig Task Manager',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          primaryColor: AppColors.primaryPurple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primaryPurple,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: AppStyles.primaryButtonStyle,
          ),
          inputDecorationTheme: const InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: AppColors.lightGreyBackground,
          ),
          checkboxTheme: CheckboxThemeData(
            fillColor: MaterialStateProperty.resolveWith<Color>((Set<MaterialState> states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.primaryPurple; // Color when selected
              }
              return AppColors.greyText.withOpacity(0.5); // Color when not selected
            }),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        initialRoute: AppRoutes.splash, // Or check auth state to decide initial route
        routes: {
          AppRoutes.login: (context) => const LoginPage(),
          AppRoutes.registration: (context) => const RegistrationPage(),
          AppRoutes.taskList: (context) => const TaskListPage(),
          AppRoutes.createTask: (context) {
            // Get userId from AuthBloc state for creating new tasks
            final authState = BlocProvider.of<AuthBloc>(context).state;
            if (authState is AuthAuthenticated) {
              return CreateEditTaskPage(userId: authState.user.uid);
            }
            return const LoginPage(); // Redirect to login if user not authenticated
          },
          AppRoutes.editTask: (context) {
            final task = ModalRoute.of(context)?.settings.arguments as TaskEntity?;
            return CreateEditTaskPage(task: task);
          },
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if (state is AuthAuthenticated) {
              // If authenticated, navigate to the task list
              return const TaskListPage();
            } else {
              // Otherwise, show the login page
              return const LoginPage();
            }
          },
        ),
      ),
    );
  }
}

