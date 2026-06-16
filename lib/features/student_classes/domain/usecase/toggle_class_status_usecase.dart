import '../../data/models/student_class_enrollment_status_change_model/class_status_request_model.dart';
import '../../data/models/student_class_enrollment_status_change_model/class_status_response_model.dart';
import '../repository/student_class_repository.dart';

class ToggleClassStatusUseCase {
  final StudentClassRepository repository;

  ToggleClassStatusUseCase(this.repository);

  Future<ClassStatusResponseModel> call({
    required ClassStatusRequestModel request,
  }) {
    return repository.toggleClassStatus(request: request);
  }
}