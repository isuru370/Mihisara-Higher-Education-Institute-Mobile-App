import '../../../../core/di/injection_container.dart';
import '../data/datasources/teacher_classes_remote_datasource.dart';
import '../data/repository/teacher_classes_repository_impl.dart';
import '../domain/repository/teacher_classes_repository.dart';
import '../domain/usecase/get_teacher_classes.dart';
import '../presentaion/bloc/teacher_classes/teacher_classes_bloc.dart';

Future<void> initTeacherClassesDI() async {
  // =====================================================
  // DATA SOURCE
  // =====================================================

  sl.registerLazySingleton<TeacherClassesRemoteDataSource>(
    () => TeacherClassesRemoteDataSourceImpl(),
  );

  // =====================================================
  // REPOSITORY
  // =====================================================

  sl.registerLazySingleton<TeacherClassesRepository>(
    () => TeacherClassesRepositoryImpl(remoteDataSource: sl()),
  );

  // =====================================================
  // USE CASE
  // =====================================================

  sl.registerLazySingleton<GetTeacherClasses>(
    () => GetTeacherClasses(repository: sl()),
  );

  sl.registerFactory<TeacherClassesBloc>(
    () => TeacherClassesBloc(getTeacherClasses: sl()),
  );
}
