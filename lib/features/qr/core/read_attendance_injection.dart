import 'package:get_it/get_it.dart';

import '../data/datasources/read_attendance_remote_datasource.dart';
import '../data/repository/read_attendance_repository_impl.dart';
import '../domain/repositories/read_attendance_repository.dart';
import '../domain/usecases/read_attendance_usecase.dart';
import '../presentation/bloc/read_attendance/read_attendance_bloc.dart';

final sl = GetIt.instance;

Future<void> initReadAttendanceDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ReadAttendanceRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ReadAttendanceRepository>(
    () => ReadAttendanceRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ReadAttendanceUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ReadAttendanceBloc(readAttendanceUseCase: sl()));
}
