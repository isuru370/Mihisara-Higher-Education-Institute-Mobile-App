import '../../../../core/di/injection_container.dart';
import '../data/datasource/teacher_timetable_remote_datasource.dart';
import '../data/repository/teacher_timetable_repository_impl.dart';
import '../domain/repository/get_teacher_timetable.dart';
import '../domain/usecase/get_teacher_timetable.dart';
import '../presentaion/bloc/teacher_timetable/teacher_timetable_bloc.dart';

Future<void> initTeacherTimetableDI() async {
  // =====================================================
  // DATA SOURCE
  // =====================================================

  sl.registerLazySingleton<TeacherTimetableRemoteDataSource>(
    () => TeacherTimetableRemoteDataSourceImpl(),
  );

  // =====================================================
  // REPOSITORY
  // =====================================================

  sl.registerLazySingleton<TeacherTimetableRepository>(
    () => TeacherTimetableRepositoryImpl(remoteDataSource: sl()),
  );

  // =====================================================
  // USE CASE
  // =====================================================

  sl.registerLazySingleton<GetTeacherTimetable>(
    () => GetTeacherTimetable(repository: sl()),
  );

  // =====================================================
  // BLOC
  // =====================================================

  sl.registerFactory<TeacherTimetableBloc>(
    () => TeacherTimetableBloc(getTeacherTimetable: sl()),
  );
}
