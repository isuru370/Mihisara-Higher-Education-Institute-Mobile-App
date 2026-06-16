import '../../data/model/newday/class_new_day_request_model.dart';
import '../../data/model/newday/class_new_day_response_model.dart';
import '../repository/class_schedule_repository.dart';

class AddNewDayUseCase {
  final ClassScheduleRepository
      repository;

  AddNewDayUseCase(
    this.repository,
  );

  Future<ClassNewDayResponseModel>
      call(
    ClassNewDayRequestModel request,
  ) {
    return repository
        .addNewDay(request);
  }
}