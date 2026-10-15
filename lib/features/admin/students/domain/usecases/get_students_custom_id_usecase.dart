import '../../data/models/student_custom_ids/students_custom_id_request_model.dart';
import '../../data/models/student_custom_ids/students_custom_id_response_model.dart';
import '../repositories/students_repository.dart';

class GetStudentsCustomIdUsecase {
  final StudentsRepository repository; 
  GetStudentsCustomIdUsecase(this.repository);

  Future<StudentsCustomIdResponseModel> execute(
    StudentsCustomIdRequestModel request,
  ) {
    return repository.getStudentCustomIds(request);
  }
}
