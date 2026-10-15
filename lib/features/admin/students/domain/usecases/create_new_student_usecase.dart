import '../../data/models/create_student/create_student_response_model.dart';
import '../../data/models/students_model.dart';
import '../repositories/students_repository.dart';

class CreateNewStudentUsecase {
  final StudentsRepository repository;

  CreateNewStudentUsecase(this.repository);

  Future<CreateStudentResponseModel> execute({
    required StudentModel student,
  }) async {
    return await repository.createNewStudent(student);
  }
}