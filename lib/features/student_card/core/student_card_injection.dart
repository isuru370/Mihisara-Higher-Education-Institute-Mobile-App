import '../../../core/di/injection_container.dart';
import '../data/datasources/student_card_remote_data_source.dart';
import '../data/repository/student_card_repository_impl.dart';
import '../domain/repository/student_card_repository.dart';
import '../domain/usecase/re_assign_student_card_usecase.dart';
import '../domain/usecase/scan_student_card_usecase.dart';
import '../presentaion/bloc/student_card/student_card_bloc.dart';

Future<void> initStudentCardDI() async {
  // DATA SOURCE
  sl.registerLazySingleton(() => StudentCardRemoteDataSource());

  // REPOSITORY
  sl.registerLazySingleton<StudentCardRepository>(
    () => StudentCardRepositoryImpl(sl()),
  );

  // USE CASES
  sl.registerLazySingleton(() => ScanStudentCardUsecase(sl()));
  sl.registerLazySingleton(() => ReAssignStudentCardUsecase(sl()));

  // BLOC
  sl.registerFactory(
    () => StudentCardBloc(
      scanStudentCardUsecase: sl(),
      reAssignStudentCardUsecase: sl(),
    ),
  );
}
