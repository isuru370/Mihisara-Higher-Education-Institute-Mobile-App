import '../../domain/repositories/attendance_repository.dart';
import '../datasources/attendance_remote_datasource.dart';
import '../models/atendance_request_model.dart';
import '../models/attendance_history/attendance_history_request_model.dart';
import '../models/attendance_history/attendance_history_response_model.dart';
import '../models/attendance_report/attendance_report_request_model.dart';
import '../models/attendance_report/attendance_report_response_model.dart';
import '../models/attendance_response_model.dart';

class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceRemoteDataSource remoteDataSource;

  AttendanceRepositoryImpl(this.remoteDataSource);

  @override
  Future<AttendanceResponseModel> markAttendance({
    required AttendanceRequestModel request,
  }) async {
    return remoteDataSource.markAttendance(request: request);
  }

  @override
  Future<AttendanceHistoryResponseModel> getAttendanceHistory({
    required AttendanceHistoryRequestModel request,
  }) async {
    return remoteDataSource.getAttendanceHistory(request: request);
  }

  @override
  Future<AttendanceReportResponseModel> getAttendanceReport({
    required AttendanceReportRequestModel request,
  }) async {
    return remoteDataSource.getAttendanceReport(request: request);
  }
}
