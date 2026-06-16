import 'package:get_it/get_it.dart';

import '../data/datasources/image_upload_remote_datasource.dart';
import '../data/respository/image_upload_repository_impl.dart';
import '../domain/repository/image_upload_repository.dart';
import '../domain/usecases/upload_image_usecase.dart';
import '../presentation/bloc/image_upload/image_upload_bloc.dart';

final sl = GetIt.instance;

Future<void> initImageUploadDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ImageUploadRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ImageUploadRepository>(
    () => ImageUploadRepositoryImpl(sl()),
  );

  // 🟢 USECASE
  sl.registerLazySingleton(() => UploadImageUsecase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => ImageUploadBloc(
      uploadImageUsecase: sl(),
    ),
  );
}
