import '../../data/models/get_class_with_grade_model/get_classes_by_grade_response_model.dart';
import '../../data/models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../../data/models/store_student_class_enrollment/create_student_response_class_model.dart';
import '../../data/models/student_class_enrollment_status_change_model/class_status_request_model.dart';
import '../../data/models/student_class_enrollment_status_change_model/class_status_response_model.dart';

abstract class StudentClassRepository {

  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required String gradeId,
  });
  Future<CreateStudentClassResponseModel> createStudentClassEnrollment({
    required CreateStudentClassRequestModel request,
  });
   Future<ClassStatusResponseModel> toggleClassStatus({
    required ClassStatusRequestModel request,
  });
}
