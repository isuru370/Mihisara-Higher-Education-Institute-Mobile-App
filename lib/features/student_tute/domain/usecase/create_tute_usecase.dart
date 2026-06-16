import '../../data/model/create_tute/create__tute_response_model.dart';
import '../../data/model/create_tute/create_tute_request_model.dart';
import '../repository/tute_repository.dart';

class CreateTuteUseCase {
  final TuteRepository repository;

  CreateTuteUseCase(this.repository);

  Future<CreateStudentTuteResponseModel> call({
    required int studentId,
    required int studentClassEnrollmentId,
    required String issuedMonth,
    bool isIssued = false,
    String? issuedAt,
    String? note,
  }) {
    final request = CreateTuteRequestModel(
      studentId: studentId,
      studentClassEnrollmentId: studentClassEnrollmentId,
      issuedMonth: issuedMonth,
      isIssued: isIssued,
      issuedAt: issuedAt,
      note: note,
    );

    return repository.createStudentTute(request);
  }
}
