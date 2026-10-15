import '../../../students/data/models/create_student/create_student_response_model.dart';
import '../../data/model/store/admission_payment_request_model.dart';
import '../repository/admission_repository.dart';

class StoreAdmissionPaymentUseCase {
  final AdmissionRepository repository;

  StoreAdmissionPaymentUseCase(
    this.repository,
  );

  Future<CreateStudentResponseModel> call(
    AdmissionPaymentRequestModel request,
  ) {
    return repository.storeAdmissionPayment(
      request,
    );
  }
}