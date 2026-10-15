import 'package:get_it/get_it.dart';

import '../data/datasources/admission_remote_datasource.dart';
import '../data/repository/admission_repository_impl.dart';
import '../domain/repository/admission_repository.dart';
import '../domain/usecase/fetch_admission_payment_usecase.dart';
import '../domain/usecase/fetch_admission_usecase.dart';
import '../domain/usecase/store_admission_payment_usecase.dart';
import '../presentaion/bloc/admission/admission_bloc.dart';

final sl = GetIt.instance;

Future<void> initAdmissionDI() async {
  // DATASOURCE
  sl.registerLazySingleton(() => AdmissionRemoteDatasource());

  // REPOSITORY
  sl.registerLazySingleton<AdmissionRepository>(
    () => AdmissionRepositoryImpl(sl()),
  );

  // USECASE
  sl.registerLazySingleton(() => FetchAdmissionUsecase(sl()));
  sl.registerLazySingleton(() => FetchAdmissionPaymentUsecase(sl()));
  sl.registerLazySingleton(() => StoreAdmissionPaymentUseCase(sl()));

  // BLOC
  sl.registerFactory(
    () => AdmissionBloc(
      fetchAdmissionUsecase: sl(),
      fetchAdmissionPaymentUsecase: sl(),
      storeAdmissionPaymentUseCase: sl(),
    ),
  );
}
