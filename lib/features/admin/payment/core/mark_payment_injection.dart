import 'package:get_it/get_it.dart';

import '../data/datasources/mark_payment_remote_data_source.dart';
import '../data/repositories/mark_payment_repository_Impl.dart';
import '../domain/repositories/mark_payment_repository.dart';
import '../domain/usecases/get_payment_history_usecase.dart';
import '../domain/usecases/get_today_payments_usecase.dart';
import '../domain/usecases/mark_payment_usecase.dart';
import '../presentaion/bloc/mark_payment/mark_payment_bloc.dart';

final sl = GetIt.instance;

Future<void> initMarkPaymentDI() async {
  // DATA SOURCE
  sl.registerLazySingleton(() => MarkPaymentRemoteDataSource());

  // REPOSITORY
  sl.registerLazySingleton<MarkPaymentRepository>(
    () => MarkPaymentRepositoryImpl(sl()),
  );

  // USE CASES
  sl.registerLazySingleton(() => MarkPaymentUseCase(sl()));
  sl.registerLazySingleton(() => GetTodayPaymentsUseCase(sl()));
  sl.registerLazySingleton(() => GetPaymentHistoryUseCase(sl()));

  // BLOC
  sl.registerFactory(
    () => MarkPaymentBloc(
      markPaymentUseCase: sl(),
      getTodayPaymentsUseCase: sl(),
      getPaymentHistoryUseCase: sl(),
    ),
  );
}