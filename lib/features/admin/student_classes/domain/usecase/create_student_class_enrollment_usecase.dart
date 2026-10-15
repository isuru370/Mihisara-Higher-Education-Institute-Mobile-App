import '../../data/models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../../data/models/store_student_class_enrollment/create_student_response_class_model.dart';
import '../repository/student_class_repository.dart';

class CreateStudentClassEnrollmentUseCase {
  final StudentClassRepository repository;

  CreateStudentClassEnrollmentUseCase(this.repository);

  Future<CreateStudentClassResponseModel> call({
    required CreateStudentClassRequestModel request,
  }) {
    return repository.createStudentClassEnrollment(request: request);
  }
}