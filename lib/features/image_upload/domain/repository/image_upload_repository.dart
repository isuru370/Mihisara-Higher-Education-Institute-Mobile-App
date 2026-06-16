import '../../data/models/image_upload/image_upload_request_model.dart';
import '../../data/models/image_upload/image_upload_response_model.dart';

abstract class ImageUploadRepository {
  Future<ImageUploadResponseModel> uploadImage(
    ImageUploadRequestModel request,
  );
}