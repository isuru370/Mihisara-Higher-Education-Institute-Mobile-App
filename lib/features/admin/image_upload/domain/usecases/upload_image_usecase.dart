import '../../data/models/image_upload/image_upload_request_model.dart';
import '../../data/models/image_upload/image_upload_response_model.dart';
import '../repository/image_upload_repository.dart';

class UploadImageUsecase {
  final ImageUploadRepository repository;

  UploadImageUsecase(this.repository);

  Future<ImageUploadResponseModel> call(
    ImageUploadRequestModel request,
  ) {
    return repository.uploadImage(request);
  }
}