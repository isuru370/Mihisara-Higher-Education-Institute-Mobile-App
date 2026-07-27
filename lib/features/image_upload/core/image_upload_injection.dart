import '../../../core/di/injection_container.dart';
import '../data/datasources/image_upload_remote_datasource.dart';
import '../data/respository/image_upload_repository_impl.dart';
import '../domain/repository/image_upload_repository.dart';
import '../domain/usecases/update_image_usecase.dart';
import '../domain/usecases/upload_image_usecase.dart';
import '../presentation/bloc/image_upload/image_upload_bloc.dart';

Future<void> initImageUploadDI() async {
  // 🔴 DATASOURCE
  sl.registerLazySingleton(() => ImageUploadRemoteDatasource());

  // 🟡 REPOSITORY
  sl.registerLazySingleton<ImageUploadRepository>(
    () => ImageUploadRepositoryImpl(sl()),
  );

  // 🟢 USECASES
  sl.registerLazySingleton(() => UploadImageUsecase(sl()));
  sl.registerLazySingleton(() => UpdateImageUseCase(sl()));

  // 🔵 BLOC
  sl.registerFactory(
    () => ImageUploadBloc(uploadImageUsecase: sl(), updateImageUseCase: sl()),
  );
}
