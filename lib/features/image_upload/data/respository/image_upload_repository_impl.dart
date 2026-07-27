import 'package:nexorait_education_app/features/image_upload/data/models/image_upload/image_update_response_model.dart';

import '../../domain/repository/image_upload_repository.dart';
import '../datasources/image_upload_remote_datasource.dart';
import '../models/image_upload/image_upload_request_model.dart';
import '../models/image_upload/image_upload_response_model.dart';

class ImageUploadRepositoryImpl implements ImageUploadRepository {
  final ImageUploadRemoteDatasource remoteDatasource;

  ImageUploadRepositoryImpl(this.remoteDatasource);

  @override
  Future<ImageUploadResponseModel> uploadImage(
    ImageUploadRequestModel request,
  ) {
    return remoteDatasource.uploadImage(request: request);
  }

  @override
  Future<ImageUpdateResponseModel> updateImage(
    ImageUploadRequestModel request,
  ) {
    return remoteDatasource.updateImage(request: request);
  }
}
