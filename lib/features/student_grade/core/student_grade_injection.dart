import 'package:get_it/get_it.dart';

import '../data/datasources/student_grade_remote_datasource.dart';
import '../data/repository/student_grade_repository_impl.dart';
import '../domain/repository/student_grade_repository.dart';
import '../domain/usecases/student_grade_usecase.dart';
import '../presentation/bloc/student_grade/student_grade_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudentGradeDI() async {
  //DATASOURCE
  sl.registerLazySingleton(() => StudentGradeRemoteDatasource());

  //REPOSITORY
  sl.registerLazySingleton<StudentGradeRepository>(
    () => StudentGradeRepositoryImpl(sl()),
  );

  //USECASE
  sl.registerLazySingleton(() => StudentGradeUsecase(sl()));

  //BLOC
  sl.registerFactory(() => StudentGradeBloc(studentGradeUsecase: sl()));
}
