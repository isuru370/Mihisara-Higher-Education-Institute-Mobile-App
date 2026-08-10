import '../../data/models/deactivate_enrollment/deactivate_enrollment_request_model.dart';
import '../../data/models/deactivate_enrollment/deactivate_enrollment_response_model.dart';
import '../repository/student_class_repository.dart';

class DeactivateEnrollmentUsecase {
  final StudentClassRepository repository;

  DeactivateEnrollmentUsecase(this.repository);

  Future<DeactivateEnrollmentResponseModel> call({
    required String enrollmentId,
  }) {
    final request = DeactivateEnrollmentRequestModel(
      enrollmentId: enrollmentId,
    );

    return repository.deactivateEnrollment(request: request);
  }
}
