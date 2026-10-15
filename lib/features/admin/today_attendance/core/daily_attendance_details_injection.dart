import 'package:get_it/get_it.dart';

import '../data/datasources/daily_attendance_details_remote_datasource.dart';
import '../data/repository/daily_attendance_details_repository_impl.dart';
import '../domain/repository/daily_attendance_details_repository.dart';
import '../domain/usecase/get_daily_attendance_details_usecase.dart';
import '../presentation/bloc/daily_attendance_details/daily_attendance_details_bloc.dart';

final sl = GetIt.instance;

Future<void> initDailyAttendanceDetailsDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => DailyAttendanceDetailsRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<DailyAttendanceDetailsRepository>(
    () => DailyAttendanceDetailsRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => GetDailyAttendanceDetailsUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => DailyAttendanceDetailsBloc(getDailyAttendanceDetailsUseCase: sl()),
  );
}
