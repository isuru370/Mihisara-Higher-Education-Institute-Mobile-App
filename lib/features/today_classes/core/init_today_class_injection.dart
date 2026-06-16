import 'package:get_it/get_it.dart';

import '../data/datasources/today_classes_remote_data_source.dart';
import '../data/repository/today_classes_repository_impl.dart';
import '../domain/repository/today_classes_repository.dart';
import '../domain/usecase/get_today_classes_usecase.dart';
import '../presentaion/bloc/today_classes/today_classes_bloc.dart';


final sl = GetIt.instance;

Future<void> initTodayAttendanceDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => TodayClassesRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<TodayClassesRepository>(
    () => TodayClassesRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => GetTodayClassesUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => TodayClassesBloc(getTodayClassesUseCase: sl()),
  );
}
