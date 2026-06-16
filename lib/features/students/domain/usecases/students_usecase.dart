import '../../data/models/students_model/students_response_model.dart';
import '../repositories/students_repository.dart';

class GetStudentsUseCase {
  final StudentsRepository repository;

  GetStudentsUseCase(this.repository);

  Future<StudentsResponseModel> execute(
  ) async {
    return await repository.getStudents();
  }
}
