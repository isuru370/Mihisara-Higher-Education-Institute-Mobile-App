
import '../../data/models/student_search_model/read_student_response_model.dart';

abstract class ReadStudentRepository {
  Future<ReadStudentResponseModel> readStudent({
    required String qrCode,
  });
}
