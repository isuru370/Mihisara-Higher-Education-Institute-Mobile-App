import '../../data/models/image_upload/image_update_response_model.dart';
import '../../data/models/image_upload/image_upload_request_model.dart';
import '../../data/models/image_upload/image_upload_response_model.dart';

abstract class ImageUploadRepository {
  Future<ImageUploadResponseModel> uploadImage(
    ImageUploadRequestModel request,
  );
  Future<ImageUpdateResponseModel> updateImage(
    ImageUploadRequestModel request,
  );
}