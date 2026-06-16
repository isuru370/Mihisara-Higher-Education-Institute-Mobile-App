import 'package:get_it/get_it.dart';

import '../data/datasources/student_image_remote_data_source.dart';
import '../data/repository/student_image_repository_impl.dart';
import '../domain/repository/student_image_repository.dart';
import '../domain/usecase/fetch_student_image_usecase.dart';
import '../domain/usecase/update_student_image_usecase.dart';
import '../presentaion/bloc/student_image/student_image_bloc.dart';

final sl = GetIt.instance;

Future<void> initStudentImageDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => StudentImageRemoteDataSource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<StudentImageRepository>(
    () => StudentImageRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => FetchStudentImageUsecase(sl()));
  sl.registerLazySingleton(() => UpdateStudentImageUsecase(sl()));

  // 🔵 BLOC

  sl.registerFactory(
    () => StudentImageBloc(
      fetchStudentImageUsecase: sl(),
      updateStudentImageUsecase: sl(),
    ),
  );
}
