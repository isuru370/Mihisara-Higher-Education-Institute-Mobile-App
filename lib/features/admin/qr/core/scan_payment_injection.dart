import '../../../../core/di/injection_container.dart';
import '../data/datasources/scan_payment_remote_datasource.dart';
import '../data/repository/scan_payment_repository_impl.dart';
import '../domain/repositories/scan_payment_repository.dart';
import '../domain/usecases/scan_payment_usecase.dart';
import '../presentation/bloc/scan_payment/scan_payment_bloc.dart';

Future<void> initScanPaymentDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton<ScanPaymentRemoteDatasource>(
    () => ScanPaymentRemoteDatasource(),
  );

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ScanPaymentRepository>(
    () => ScanPaymentRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton<ScanPaymentUsecase>(() => ScanPaymentUsecase(sl()));

  // 🔵 BLOC
  sl.registerFactory<ScanPaymentBloc>(
    () => ScanPaymentBloc(scanPaymentUsecase: sl()),
  );
}
