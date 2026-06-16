import 'package:get_it/get_it.dart';

import '../data/datasources/tute_remote_datasource.dart';
import '../data/repository/tute_repository_impl.dart';
import '../domain/repository/tute_repository.dart';
import '../domain/usecase/create_tute_usecase.dart';
import '../domain/usecase/get_student_history_tute_usecase.dart';
import '../presentation/bloc/tute/tute_bloc.dart';

final sl = GetIt.instance;

Future<void> initTuteDI() async {
  //DATASOURCE
  sl.registerLazySingleton(() => TuteRemoteDataSource());

  //REPOSITORY
  sl.registerLazySingleton<TuteRepository>(() => TuteRepositoryImpl(sl()));

  //USECASE
  sl.registerLazySingleton(() => GetStudentTuteHistoryUseCase(sl()));
  sl.registerLazySingleton(() => CreateTuteUseCase(sl()));

  //BLOC
  sl.registerFactory(
    () => TuteBloc(getStudentTuteHistoryUseCase: sl(), createTuteUseCase: sl()),
  );
}
