import '../../data/model/admission/admission_response_model.dart';
import '../repository/admission_repository.dart';

class FetchAdmissionUsecase {
  final AdmissionRepository repository;

  FetchAdmissionUsecase(this.repository);

  Future<AdmissionResponseModel> call() {
    return repository.fetchAdmissionData();
  }
}
