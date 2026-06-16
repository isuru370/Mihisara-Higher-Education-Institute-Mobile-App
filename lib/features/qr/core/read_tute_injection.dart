import 'package:get_it/get_it.dart';

import '../data/datasources/read_tute_remote_datasource.dart';
import '../data/repository/read_tute_repository_impl.dart';
import '../domain/repositories/read_tute_repository.dart';
import '../domain/usecases/read_tute_usecase.dart';
import '../presentation/bloc/read_tute/read_tute_bloc.dart';

final sl = GetIt.instance;

Future<void> initReadTuteDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ReadTuteRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ReadTuteRepository>(
    () => ReadTuteRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ReadTuteUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ReadTuteBloc(readTuteUseCase: sl()));
}
