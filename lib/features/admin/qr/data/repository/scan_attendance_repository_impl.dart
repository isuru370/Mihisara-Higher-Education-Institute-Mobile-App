import '../../domain/repositories/sacn_attendance_repository.dart';
import '../datasources/scan_attendance_remote_datasource.dart';
import '../model/scan_attendance_new/scan_attendance_request_model.dart';
import '../model/scan_attendance_new/scan_attendance_response_model.dart';

class ScanAttendanceRepositoryImpl implements ScanAttendanceRepository {
  final ScanAttendanceRemoteDatasource remoteDatasource;

  ScanAttendanceRepositoryImpl(this.remoteDatasource);

  @override
  Future<ScanAttendanceResponseModel> readAttendance({
    required ScanAttendanceRequestModel requestModel,
  }) {
    return remoteDatasource.readAttendance(requestModel: requestModel);
  }
}
