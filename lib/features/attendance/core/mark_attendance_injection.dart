import 'package:get_it/get_it.dart';

import '../data/datasources/attendance_remote_datasource.dart';
import '../data/repositories/attendance_repository_impl.dart';
import '../domain/repositories/attendance_repository.dart';
import '../domain/usecases/get_attendance_history_usecase.dart';
import '../domain/usecases/get_attendance_report_usecase.dart';
import '../domain/usecases/mark_attendance_usecase.dart';
import '../presentaion/bloc/attendance/attendance_bloc.dart';

final sl = GetIt.instance;

Future<void> initMarkAttendanceDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => AttendanceRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<AttendanceRepository>(
    () => AttendanceRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => MarkAttendanceUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceHistoryUseCase(sl()));
  sl.registerLazySingleton(() => GetAttendanceReportUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => AttendanceBloc(
      markAttendanceUseCase: sl(),
      getAttendanceHistoryUseCase: sl(),
      getAttendanceReportUseCase: sl(),
    ),
  );
}
