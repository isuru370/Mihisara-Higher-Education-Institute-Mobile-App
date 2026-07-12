import '../../data/model/scan_attendance_new/scan_attendance_request_model.dart';
import '../../data/model/scan_attendance_new/scan_attendance_response_model.dart';

abstract class ScanAttendanceRepository {
  Future<ScanAttendanceResponseModel> readAttendance({
    required ScanAttendanceRequestModel requestModel,
  });
}