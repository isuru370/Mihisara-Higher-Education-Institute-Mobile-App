import 'package:get_it/get_it.dart';

import '../data/datasources/class_schedule_remote_datasource.dart';
import '../data/repository/class_schedule_repository_impl.dart';
import '../domain/repository/class_schedule_repository.dart';
import '../domain/usecase/add_new_day_usecase.dart';
import '../domain/usecase/attendance_schedule_usecase.dart';
import '../domain/usecase/cancel_class_schedule_usecase.dart';
import '../domain/usecase/fetch_class_category_usecase.dart';
import '../domain/usecase/fetch_class_schedule_usecase.dart';
import '../domain/usecase/fetch_ongoing_class_usecase.dart';
import '../domain/usecase/update_class_schedule_usecase.dart';
import '../presentaion/bloc/class_category/class_category_bloc.dart';
import '../presentaion/bloc/class_schedule/class_schedule_bloc.dart';
import '../presentaion/bloc/ongoing_class/ongoing_class_bloc.dart';

final sl = GetIt.instance;

Future<void> classScheduleDI() async {
  // DATA SOURCE
  sl.registerLazySingleton(() => ClassScheduleRemoteDatasource());

  // REPOSITORY
  sl.registerLazySingleton<ClassScheduleRepository>(
    () => ClassScheduleRepositoryImpl(sl()),
  );

  // USE CASES
  sl.registerLazySingleton<FetchOngoingClassUseCase>(
    () => FetchOngoingClassUseCase(sl()),
  );

  sl.registerLazySingleton<FetchClassScheduleUseCase>(
    () => FetchClassScheduleUseCase(sl()),
  );

  sl.registerLazySingleton<AddNewDayUseCase>(() => AddNewDayUseCase(sl()));

  sl.registerLazySingleton<UpdateClassScheduleUseCase>(
    () => UpdateClassScheduleUseCase(sl()),
  );

  sl.registerLazySingleton<CancelClassScheduleUseCase>(
    () => CancelClassScheduleUseCase(sl()),
  );
  sl.registerLazySingleton<FetchClassCategoryUseCase>(
    () => FetchClassCategoryUseCase(sl()),
  );

  sl.registerLazySingleton<AttendanceScheduleUseCase>(
    () => AttendanceScheduleUseCase(sl()),
  );

  // BLOC
  sl.registerFactory<ClassScheduleBloc>(
    () => ClassScheduleBloc(
      fetchClassScheduleUseCase: sl(),
      addNewDayUseCase: sl(),
      updateClassScheduleUseCase: sl(),
      cancelClassScheduleUseCase: sl(),
      attendanceScheduleUseCase: sl(),
    ),
  );

  sl.registerFactory<OngoingClassBloc>(
    () => OngoingClassBloc(fetchOngoingClassUseCase: sl()),
  );
  sl.registerFactory<ClassCategoryBloc>(
    () => ClassCategoryBloc(fetchClassCategoryUseCase: sl()),
  );
}
