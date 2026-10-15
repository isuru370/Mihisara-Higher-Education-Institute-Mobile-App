import '../../domain/repositories/read_attendance_repository.dart';
import '../datasources/read_attendance_remote_datasource.dart';
import '../model/read_attendance/read_attendance_request_model.dart';
import '../model/read_attendance/read_attendance_response_model.dart';

class ReadAttendanceRepositoryImpl implements ReadAttendanceRepository {
  final ReadAttendanceRemoteDatasource remoteDataSource;

  ReadAttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<ReadAttendanceResponseModel> readAttendance({
    required ReadAttendanceRequestModel requestModel,
  }) {
    return remoteDataSource.readAttendance(requestModel: requestModel);
  }
}
