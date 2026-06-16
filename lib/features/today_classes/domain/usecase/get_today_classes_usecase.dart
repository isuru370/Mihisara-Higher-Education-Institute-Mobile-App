import '../../data/models/today_classes_response_model.dart';
import '../repository/today_classes_repository.dart';

class GetTodayClassesUseCase {
  final TodayClassesRepository repository;

  GetTodayClassesUseCase(this.repository);

  Future<TodayClassesResponseModel> call() {
    return repository.getTodayClasses();
  }
}