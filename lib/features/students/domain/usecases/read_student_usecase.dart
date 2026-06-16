import '../../data/models/student_search_model/read_student_response_model.dart';
import '../repositories/read_student_repository.dart';

class ReadStudentUsecase {
  final ReadStudentRepository repository;

  ReadStudentUsecase(this.repository);

  Future<ReadStudentResponseModel> call({
    required String qrCode,
  }) {
    return repository.readStudent(qrCode: qrCode);
  }
}
