import 'package:get_it/get_it.dart';

import '../data/datasources/scan_attendance_remote_datasource.dart';
import '../data/repository/scan_attendance_repository_impl.dart';
import '../domain/repositories/sacn_attendance_repository.dart';
import '../domain/usecases/scan_attendance_usecase.dart';
import '../presentation/bloc/scan_attendance/scan_attendance_bloc.dart';


final sl = GetIt.instance;

Future<void> initScanAttendanceDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ScanAttendanceRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ScanAttendanceRepository>(
    () => ScanAttendanceRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ScanAttendanceUsecase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ScanAttendanceBloc(scanAttendanceUseCase: sl()));
}
