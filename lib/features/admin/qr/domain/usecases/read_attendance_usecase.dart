import '../../data/model/read_attendance/read_attendance_request_model.dart';
import '../../data/model/read_attendance/read_attendance_response_model.dart';

import '../repositories/read_attendance_repository.dart';

class ReadAttendanceUseCase {
  final ReadAttendanceRepository repository;

  ReadAttendanceUseCase(this.repository);

  Future<ReadAttendanceResponseModel> call({
    required ReadAttendanceRequestModel requestModel,
  }) {
    return repository.readAttendance(
      requestModel: requestModel,
    );
  }
}