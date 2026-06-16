import 'package:get_it/get_it.dart';

import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/usecases/login_usecase.dart';
import '../domain/usecases/logout_usecase.dart';
import '../presentation/bloc/auth/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> initAuthDI() async {
  //Datasource
  sl.registerLazySingleton(() => AuthRemoteDataSource());

  //Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //Usecases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  
  //Bloc
  sl.registerFactory(() => AuthBloc(loginUseCase: sl(), logoutUseCase: sl()));
}
