/// lib/di/injection_container.dart
///
/// Sets up GetIt for dependency injection across the application.
/// This centralizes the creation and provision of all dependencies,
/// making the app more testable and maintainable.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get_it/get_it.dart';
import 'package:task_manager_app/features/auth/data/datasources/auth_remote_datasource_impl.dart';
import 'package:task_manager_app/features/task/data/datasources/task_remote_datasource_impl.dart';

// Core
import '../core/errors/failures.dart';
import '../core/usecases/usecase.dart';

// Auth Feature
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/auth/domain/usecases/login_user.dart';
import '../features/auth/domain/usecases/register_user.dart';
import '../features/auth/domain/usecases/logout_user.dart';
import '../features/auth/domain/usecases/get_auth_state_changes.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';

// Task Feature
import '../features/task/data/datasources/task_remote_datasource.dart';
import '../features/task/data/repositories/task_repository_impl.dart';
import '../features/task/domain/repositories/task_repository.dart';
import '../features/task/domain/usecases/create_task.dart';
import '../features/task/domain/usecases/delete_task.dart';
import '../features/task/domain/usecases/get_tasks.dart';
import '../features/task/domain/usecases/update_task.dart';
import '../features/task/domain/usecases/toggle_task_completion.dart';
import '../features/task/presentation/bloc/task_bloc.dart';
import 'package:uuid/uuid.dart';


final sl = GetIt.instance; // sl stands for Service Locator

Future<void> init() async {
  // ----------------------- Features -----------------------

  // Auth Feature
  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      loginUser: sl(),
      registerUser: sl(),
      logoutUser: sl(),
      getAuthStateChanges: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => LoginUser(sl()));
  sl.registerLazySingleton(() => RegisterUser(sl()));
  sl.registerLazySingleton(() => LogoutUser(sl()));
  sl.registerLazySingleton(() => GetAuthStateChanges(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl()),
  );

  // Data Sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(auth: sl()),
  );

  // Task Feature
  // Bloc
  sl.registerFactory(
    () => TaskBloc(
      createTask: sl(),
      deleteTask: sl(),
      getTasks: sl(),
      updateTask: sl(),
      toggleTaskCompletion: sl(),
    ),
  );

  // Use Cases
  sl.registerLazySingleton(() => CreateTask(sl()));
  sl.registerLazySingleton(() => DeleteTask(sl()));
  sl.registerLazySingleton(() => GetTasks(sl()));
  sl.registerLazySingleton(() => UpdateTask(sl()));
  sl.registerLazySingleton(() => ToggleTaskCompletion(sl()));

  // Repository
  sl.registerLazySingleton<TaskRepository>(
    () => TaskRepositoryImpl(remoteDataSource: sl(), firestore: sl()), // Corrected: ensure 'firestore' is a named parameter
  );

  // Data Sources
  sl.registerLazySingleton<TaskRemoteDataSource>(
    () => TaskRemoteDataSourceImpl(firestore: sl()),
  );


  // ----------------------- External -----------------------
  // Firebase Auth instance
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  // Firebase Firestore instance
  sl.registerLazySingleton(() => FirebaseFirestore.instance);
  // Uuid instance
  sl.registerLazySingleton(() => const Uuid());
}

