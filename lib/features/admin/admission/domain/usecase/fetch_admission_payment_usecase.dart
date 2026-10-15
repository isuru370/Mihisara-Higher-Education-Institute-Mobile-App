import '../repository/admission_repository.dart';

class FetchAdmissionPaymentUsecase {
  final AdmissionRepository repository;

  FetchAdmissionPaymentUsecase(this.repository);
  Future call() {
    return repository.fetchAdmissionPaymentData();
  }
}
