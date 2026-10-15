import 'package:get_it/get_it.dart';

import '../../qr/data/datasources/read_student_remote_datasource.dart';
import '../../qr/presentation/bloc/read_student/read_student_bloc.dart';
import '../data/repositories/read_student_repository_impl.dart';
import '../domain/repositories/read_student_repository.dart';
import '../domain/usecases/read_student_usecase.dart';


final sl = GetIt.instance;

Future<void> initReadStudentDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ReadStudentRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ReadStudentRepository>(
    () => ReadStudentRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => ReadStudentUsecase(sl()));

  // 🔵 BLOC
  sl.registerFactory(() => ReadStudentBloc(readStudentUseCase: sl()));
}
