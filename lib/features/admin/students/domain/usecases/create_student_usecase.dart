import '../../data/models/create_student/create_student_response_model.dart';
import '../../data/models/students_model.dart';
import '../repositories/students_repository.dart';

class CreateStudentUsecase {
  final StudentsRepository repository;

  CreateStudentUsecase(this.repository);

  Future<CreateStudentResponseModel> execute({
    required StudentModel student,
  }) async {
    return await repository.createStudent(student);
  }
}