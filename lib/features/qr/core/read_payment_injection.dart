import 'package:get_it/get_it.dart';

import '../data/datasources/read_payment_remote_datasource.dart';
import '../data/repository/read_payment_repositoryImpl.dart';
import '../domain/repositories/read_payment_repository.dart';
import '../domain/usecases/read_payment_usecase.dart';
import '../presentation/bloc/read_payment/read_payment_bloc.dart';

final sl = GetIt.instance;

Future<void> initReadPaymentDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ReadPaymentRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ReadPaymentRepository>(
    () => ReadPaymentRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ReadPaymentUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ReadPaymentBloc(readPaymentUseCase: sl()));
}
