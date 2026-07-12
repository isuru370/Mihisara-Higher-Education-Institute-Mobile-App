import '../../data/models/atendance_request_model.dart';
import '../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../data/models/attendance_history/attendance_history_response_model.dart';
import '../../data/models/attendance_report/attendance_report_request_model.dart';
import '../../data/models/attendance_report/attendance_report_response_model.dart';
import '../../data/models/attendance_response_model.dart';

abstract class AttendanceRepository {
  Future<AttendanceResponseModel> markAttendance({
    required AttendanceRequestModel request,
  });
   Future<AttendanceHistoryResponseModel> getAttendanceHistory({
    required AttendanceHistoryRequestModel request,
  });
  Future<AttendanceReportResponseModel> getAttendanceReport({
    required AttendanceReportRequestModel request,
  });
}