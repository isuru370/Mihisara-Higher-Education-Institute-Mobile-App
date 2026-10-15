import '../../../../core/di/injection_container.dart';
import '../data/datasource/teacher_students_remote_datasource.dart';
import '../data/repository/teacher_students_repository_impl.dart';
import '../domain/repository/teacher_students_repository.dart';
import '../domain/usecase/get_teacher_students.dart';
import '../presentaion/bloc/teacher_students/teacher_students_bloc.dart';

Future<void> initTeacherStudentsDI() async {
  // =====================================================
  // DATA SOURCE
  // =====================================================

  sl.registerLazySingleton<TeacherStudentsRemoteDataSource>(
    () => TeacherStudentsRemoteDataSourceImpl(),
  );

  // =====================================================
  // REPOSITORY
  // =====================================================

  sl.registerLazySingleton<TeacherStudentsRepository>(
    () => TeacherStudentsRepositoryImpl(remoteDataSource: sl()),
  );

  // =====================================================
  // USE CASE
  // =====================================================

  sl.registerLazySingleton<GetTeacherStudents>(
    () => GetTeacherStudents(repository: sl()),
  );

  // =====================================================
  // BLOC
  // =====================================================

  sl.registerFactory<TeacherStudentsBloc>(
    () => TeacherStudentsBloc(getTeacherStudents: sl()),
  );
}
