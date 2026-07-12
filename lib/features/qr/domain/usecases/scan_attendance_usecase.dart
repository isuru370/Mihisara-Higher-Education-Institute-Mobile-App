import '../../data/model/scan_attendance_new/scan_attendance_request_model.dart';
import '../../data/model/scan_attendance_new/scan_attendance_response_model.dart';
import '../repositories/sacn_attendance_repository.dart';


class ScanAttendanceUsecase {
  final ScanAttendanceRepository repository;

  ScanAttendanceUsecase(this.repository);

  Future<ScanAttendanceResponseModel> call({
    required ScanAttendanceRequestModel requestModel,
  }) {
    return repository.readAttendance(
      requestModel: requestModel,
    );
  }
}