import '../../data/models/student_classes_model/student_class_response_model.dart';
import '../../data/models/student_classes_model/student_request_model.dart';

abstract class StudentClassesRepository {
  Future<StudentClassResponseModel> getStudentClasses(
    StudentRequestModel request,
  );
}
