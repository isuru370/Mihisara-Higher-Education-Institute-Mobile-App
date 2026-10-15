import '../../data/model/ongoing/ongoing_class_response_model.dart';
import '../repository/class_schedule_repository.dart';

class FetchOngoingClassUseCase {
  final ClassScheduleRepository
      repository;

  FetchOngoingClassUseCase(
    this.repository,
  );

  Future<OngoingClassResponseModel>
      call() {
    return repository
        .fetchOngoingClass();
  }
}