import 'package:get_it/get_it.dart';

import '../data/datasources/read_student_classes_remote_datasource.dart';
import '../data/repository/read_student_classes_repository_impl.dart';
import '../domain/repositories/read_student_classes_repository.dart';
import '../domain/usecases/read_student_classes_usecase.dart';
import '../presentation/bloc/read_student_classes/read_student_classes_bloc.dart';

final sl = GetIt.instance;

Future<void> initReadStudentClassDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ReadStudentClassesRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ReadStudentClassesRepository>(
    () => ReadStudentClassesRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ReadStudentClassesUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ReadStudentClassesBloc(readStudentClassesUseCase: sl()));
}
