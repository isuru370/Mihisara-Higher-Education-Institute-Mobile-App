import '../../data/model/read_attendance/read_attendance_request_model.dart';
import '../../data/model/read_attendance/read_attendance_response_model.dart';

abstract class ReadAttendanceRepository {

  Future<ReadAttendanceResponseModel>
  readAttendance({
    required ReadAttendanceRequestModel requestModel,
  });
}