import '../../data/model/student_image_update/student_image_response_model.dart';
import '../../data/model/student_image_update/student_image_update_request_model.dart';

import '../repository/student_image_repository.dart';

class UpdateStudentImageUsecase {

  final StudentImageRepository repository;

  UpdateStudentImageUsecase(this.repository);

  Future<StudentImageUpdateResponseModel> call(
    StudentImageUpdateRequestModel request,
  ) {
    return repository.updateStudentImage(
      request,
    );
  }
}