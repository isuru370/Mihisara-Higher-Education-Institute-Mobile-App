import '../../data/model/student_image_response_model.dart';
import '../../data/model/student_image_update/student_image_response_model.dart';
import '../../data/model/student_image_update/student_image_update_request_model.dart';


abstract class StudentImageRepository {

  Future<StudentImageResponseModel> getStudentImage();

  Future<StudentImageUpdateResponseModel> updateStudentImage(
    StudentImageUpdateRequestModel request,
  );
}