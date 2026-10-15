import '../../data/model/student_image_response_model.dart';
import '../repository/student_image_repository.dart';

class FetchStudentImageUsecase {
  final StudentImageRepository repository;

  FetchStudentImageUsecase(this.repository);

  Future<StudentImageResponseModel> call() {
    return repository.getStudentImage();
  }
}
