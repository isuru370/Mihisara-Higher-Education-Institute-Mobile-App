import '../../data/model/schedule/class_schedule_request_model.dart';
import '../../data/model/schedule/class_schedule_response_model.dart';
import '../repository/class_schedule_repository.dart';

class FetchClassScheduleUseCase {
  final ClassScheduleRepository
      repository;

  FetchClassScheduleUseCase(
    this.repository,
  );

  Future<ClassScheduleResponseModel>
      call(
    ClassScheduleRequestModel request,
  ) {
    return repository
        .fetchClassSchedule(request);
  }
}