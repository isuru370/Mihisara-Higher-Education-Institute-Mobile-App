import '../../data/model/create_tute/create__tute_response_model.dart';
import '../../data/model/create_tute/create_tute_request_model.dart';
import '../../data/model/fetch_tute/fetch_tute_response_model.dart';

abstract class TuteRepository {
  Future<FetchStudentTuteResponseModel> getStudentTuteHistory(
    int studentId,
    int enrolledId,
  );

  Future<CreateStudentTuteResponseModel> createStudentTute(
    CreateTuteRequestModel request,
  );
}