import '../../data/model/update/update_class_schedule_request_model.dart';
import '../../data/model/update/update_class_schedule_response_model.dart';
import '../repository/class_schedule_repository.dart';

class UpdateClassScheduleUseCase {
  final ClassScheduleRepository repository;

  UpdateClassScheduleUseCase(this.repository);

  Future<UpdateClassScheduleResponseModel> call(
    UpdateClassScheduleRequestModel request,
  ) {
    return repository.updateSchedule(request);
  }
}
