import '../../data/models/student_classes_model/student_class_response_model.dart';
import '../../data/models/student_classes_model/student_request_model.dart';
import '../repositories/student_classes_repository.dart';

class StudentClassesUsecase {
  final StudentClassesRepository repository; // ✅ correct

  StudentClassesUsecase(this.repository);

  Future<StudentClassResponseModel> execute(StudentRequestModel request) async {
    return await repository.getStudentClasses(request);
  }
}
