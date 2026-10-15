import '../../data/models/atendance_request_model.dart';
import '../../data/models/attendance_response_model.dart';
import '../repositories/attendance_repository.dart';

class MarkAttendanceUseCase {
  final AttendanceRepository repository;

  MarkAttendanceUseCase(this.repository);

  Future<AttendanceResponseModel> call({
    required AttendanceRequestModel request,
  }) {
    return repository.markAttendance(request: request);
  }
}