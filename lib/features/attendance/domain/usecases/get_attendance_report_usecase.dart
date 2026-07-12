import '../../data/models/attendance_report/attendance_report_request_model.dart';
import '../../data/models/attendance_report/attendance_report_response_model.dart';
import '../../domain/repositories/attendance_repository.dart';

class GetAttendanceReportUseCase {
  final AttendanceRepository repository;

  GetAttendanceReportUseCase(this.repository);

  Future<AttendanceReportResponseModel> execute({
    required AttendanceReportRequestModel request,
  }) async {
    try {
      final response = await repository.getAttendanceReport(request: request);
      return response;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
