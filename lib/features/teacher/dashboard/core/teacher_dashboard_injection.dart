import '../../../../core/di/injection_container.dart';
import '../data/datasources/teacher_dashboard_remote_datasource.dart';
import '../data/repositories/dashboard_repository_impl.dart';
import '../domain/repositories/dashboard_repository.dart';
import '../domain/repositories/usecases/get_teacher_dashboard.dart';
import '../presentaion/bloc/teacher_dashboard/teacher_dashboard_bloc.dart';

Future<void> initTeacherDashboardDI() async {
  // DATA SOURCE
  sl.registerLazySingleton<TeacherDashboardRemoteDataSource>(
    () => TeacherDashboardRemoteDataSourceImpl(),
  );

  // REPOSITORY
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(
      remoteDataSource: sl(),
    ),
  );

  // USECASE
  sl.registerLazySingleton<GetTeacherDashboard>(
    () => GetTeacherDashboard(
      repository: sl(),
    ),
  );

  // BLOC
  sl.registerFactory<TeacherDashboardBloc>(
    () => TeacherDashboardBloc(
      getTeacherDashboard: sl(),
    ),
  );
}