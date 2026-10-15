import '../../data/model/cancel/class_cancel_request_model.dart';
import '../../data/model/cancel/class_cancel_response_model.dart';
import '../repository/class_schedule_repository.dart';

class CancelClassScheduleUseCase {
  final ClassScheduleRepository repository;

  CancelClassScheduleUseCase(this.repository);

  Future<ClassCancelResponseModel> call(ClassCancelRequestModel request) {
    return repository.cancelSchedule(request);
  }
}
