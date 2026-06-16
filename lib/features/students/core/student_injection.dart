import 'package:get_it/get_it.dart';

import '../data/datasources/students_remote_data_source.dart';
import '../data/repositories/students_repository_impl.dart';
import '../domain/repositories/students_repository.dart';
import '../domain/usecases/create_student_usecase.dart';
import '../domain/usecases/get_students_custom_id_usecase.dart';
import '../domain/usecases/students_usecase.dart';
import '../presentaion/bloc/students/students_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudentDI() async {
  //DATASOURCE
  sl.registerLazySingleton(() => StudentRemoteDataSource());

  //REPOSITORY
  sl.registerLazySingleton<StudentsRepository>(
    () => StudentRepositoryImpl(sl()),
  );

  //USECASE
  sl.registerLazySingleton(() => CreateStudentUsecase(sl()));
  sl.registerLazySingleton(() => GetStudentsUseCase(sl()));
  sl.registerLazySingleton(() => GetStudentsCustomIdUsecase(sl()));

  //BLOC
  sl.registerFactory(
    () => StudentsBloc(
      createStudentUsecase: sl(),
      getStudentsUseCase: sl(),
      getStudentsCustomIdUsecase: sl(),
    ),
  );
}
