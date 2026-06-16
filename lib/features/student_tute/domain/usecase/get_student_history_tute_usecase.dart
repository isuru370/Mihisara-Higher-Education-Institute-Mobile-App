import '../../data/model/fetch_tute/fetch_tute_response_model.dart';
import '../repository/tute_repository.dart';

class GetStudentTuteHistoryUseCase {
  final TuteRepository repository;

  GetStudentTuteHistoryUseCase(this.repository);

  Future<FetchStudentTuteResponseModel> call(
    int studentId,
    int enrolledId,
  ) {
    return repository.getStudentTuteHistory(
      studentId,
      enrolledId,
    );
  }
}