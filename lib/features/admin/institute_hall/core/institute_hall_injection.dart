import 'package:get_it/get_it.dart';

import '../data/datasources/institute_hall_remote_datasource.dart';
import '../data/repository/institute_hall_repository_impl.dart';
import '../domain/repository/institute_hall_repository.dart';
import '../domain/usecase/fetch_institute_hall.dart';
import '../presentaion/bloc/institute_hall/institute_hall_bloc.dart';

final sl = GetIt.instance;

Future<void> initInstituteHallsDI() async {
  //DATASOURCE
  sl.registerLazySingleton(() => InstituteHallRemoteDatasource());

  //REPOSITORY
  sl.registerLazySingleton<InstituteHallRepository>(
    () => InstituteHallRepositoryImpl(sl()),
  );

  //USECASE
  sl.registerLazySingleton(() => FetchInstituteHall(sl()));

  //BLOC
  sl.registerFactory(() => InstituteHallBloc(fetchInstituteHall: sl()));
}
