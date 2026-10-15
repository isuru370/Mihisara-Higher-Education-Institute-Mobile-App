import '../../data/model/class_categry/class_category_request_model.dart';
import '../../data/model/class_categry/class_category_response_model.dart';
import '../repository/class_schedule_repository.dart';

class FetchClassCategoryUseCase {
  final ClassScheduleRepository repository;

  FetchClassCategoryUseCase(this.repository);

  Future<ClassCategoryResponseModel> call(ClassCategoryRequestModel request) {
    return repository.fetchClassCategory(request);
  }
}
