import '../../domain/repository/tute_repository.dart';
import '../datasources/tute_remote_datasource.dart';
import '../model/create_tute/create__tute_response_model.dart';
import '../model/create_tute/create_tute_request_model.dart';
import '../model/fetch_tute/fetch_tute_response_model.dart';

class TuteRepositoryImpl implements TuteRepository {
  final TuteRemoteDataSource remoteDataSource;

  TuteRepositoryImpl(this.remoteDataSource);

  @override
  Future<FetchStudentTuteResponseModel> getStudentTuteHistory(
    int studentId,
    int enrolledId,
  ) {
    return remoteDataSource.getStudentTuteHistory(
      studentId: studentId,
      enrolledId: enrolledId,
    );
  }

  @override
  Future<CreateStudentTuteResponseModel> createStudentTute(
    CreateTuteRequestModel request,
  ) {
    return remoteDataSource.createStudentTute(request: request);
  }
}
