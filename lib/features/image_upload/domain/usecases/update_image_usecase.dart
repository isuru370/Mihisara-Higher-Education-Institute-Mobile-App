import '../../data/models/image_upload/image_upload_request_model.dart';
import '../../data/models/image_upload/image_update_response_model.dart';
import '../repository/image_upload_repository.dart';

class UpdateImageUseCase {
  final ImageUploadRepository repository;

  UpdateImageUseCase(this.repository);

  Future<ImageUpdateResponseModel> call(
    ImageUploadRequestModel request,
  ) {
    return repository.updateImage(request);
  }
}