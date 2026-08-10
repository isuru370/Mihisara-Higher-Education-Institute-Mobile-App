import '../../data/models/delete_attendance/delete_attendance_request_model.dart';
import '../../data/models/delete_attendance/delete_attendance_response_model.dart';
import '../repositories/attendance_repository.dart';

class DeleteAttendanceUsecase {
  final AttendanceRepository repository;

  DeleteAttendanceUsecase(this.repository);

  Future<DeleteAttendanceResponseModel> call({
    required DeleteAttendanceRequestModel request,
  }) {
    return repository.deleteAttendance(request: request);
  }
}
