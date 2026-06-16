import 'package:get_it/get_it.dart';

import '../data/datasources/student_class_remote_datasource.dart';
import '../data/repository/student_class_repository_impl.dart';
import '../domain/repository/student_class_repository.dart';
import '../domain/usecase/create_student_class_enrollment_usecase.dart';
import '../domain/usecase/get_classes_by_grade_usecase.dart';
import '../domain/usecase/toggle_class_status_usecase.dart';
import '../presentaion/bloc/class_room/class_room_bloc.dart';

final sl = GetIt.instance;

Future<void> initClassRoomDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton<StudentClassRemoteDatasource>(
    () => StudentClassRemoteDatasource(),
  );

  // 🟡 REPOSITORY
  sl.registerLazySingleton<StudentClassRepository>(
    () => StudentClassRepositoryImpl(sl()),
  );

  // 🟢 USECASES
  sl.registerLazySingleton<GetClassesByGradeUseCase>(
    () => GetClassesByGradeUseCase(sl()),
  );

  sl.registerLazySingleton<CreateStudentClassEnrollmentUseCase>(
    () => CreateStudentClassEnrollmentUseCase(sl()),
  );

  sl.registerLazySingleton<ToggleClassStatusUseCase>(
    () => ToggleClassStatusUseCase(sl()),
  );

  // 🔵 BLOC
  sl.registerFactory<ClassRoomBloc>(
    () => ClassRoomBloc(
      getClassesByGradeUsecase: sl(),
      createStudentClassEnrollmentUsecase: sl(),
      toggleClassStatusUseCase: sl(),
    ),
  );
}
