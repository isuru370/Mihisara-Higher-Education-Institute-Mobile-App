import 'package:get_it/get_it.dart';

import '../data/datasources/mobile_dashboard_remote_datasource.dart';
import '../data/repositories/mobile_dashboard_repository_impl.dart';
import '../domain/repositories/mobile_dashboard_repository.dart';
import '../domain/usecases/get_mobile_dashboard_usecase.dart';
import '../presentaion/bloc/mobile_dashboard/mobile_dashboard_bloc.dart';

final sl = GetIt.instance;

Future<void> initMobileDashboardDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => MobileDashboardRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<MobileDashboardRepository>(
    () => MobileDashboardRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => GetMobileDashboardUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => MobileDashboardBloc(getMobileDashboardUseCase: sl()),
  );
}
