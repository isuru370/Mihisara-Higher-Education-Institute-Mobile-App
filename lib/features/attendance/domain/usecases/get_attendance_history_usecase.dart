import '../../data/models/attendance_history/attendance_history_request_model.dart';
import '../../data/models/attendance_history/attendance_history_response_model.dart';
import '../repositories/attendance_repository.dart';

class GetAttendanceHistoryUseCase {
  final AttendanceRepository repository;

  GetAttendanceHistoryUseCase(this.repository);

  Future<AttendanceHistoryResponseModel> call({
    required AttendanceHistoryRequestModel request,
  }) {
    return repository.getAttendanceHistory(request: request);
  }
}