import '../../data/model/read_student_classes/read_student_classes_request_model.dart';
import '../../data/model/read_student_classes/read_student_classes_response_model.dart';
import '../repositories/read_student_classes_repository.dart';

class ReadStudentClassesUseCase {
  final ReadStudentClassesRepository repository;

  ReadStudentClassesUseCase(this.repository);

  Future<ReadStudentClassesResponseModel> call(
    ReadStudentClassesRequestModel request,
  ) {
    return repository.readStudentClasses(request);
  }
}