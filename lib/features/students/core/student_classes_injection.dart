import 'package:get_it/get_it.dart';

import '../data/datasources/student_classes_remote_data_source.dart';
import '../data/repositories/student_classes_repository_Impl.dart';
import '../domain/repositories/student_classes_repository.dart';
import '../domain/usecases/student_classes_usecase.dart';
import '../presentaion/bloc/student_classes/student_classes_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudentClassesDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => StudentClassesRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<StudentClassesRepository>(
    () => StudentClassesRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => StudentClassesUsecase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => StudentClassesBloc(
      studentClassesUsecase: sl(),
    ),
  );
}
