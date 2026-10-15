import '../../data/model/attendance_schedule/attendance_schedule_request_model.dart';
import '../../data/model/attendance_schedule/attendance_schedule_response_model.dart';
import '../repository/class_schedule_repository.dart';

class AttendanceScheduleUseCase {
  final ClassScheduleRepository repository;

  AttendanceScheduleUseCase(this.repository);

  Future<AttendanceScheduleResponseModel> call({
    required AttendanceScheduleRequestModel request,
  }) {
    return repository.fetchClassCategoryById(request);
  }
}