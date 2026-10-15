import '../../data/model/student_card_request_model.dart';
import '../../data/model/student_card_response_model.dart';
import '../repository/student_card_repository.dart';

class ScanStudentCardUsecase {

  final StudentCardRepository repository;

  ScanStudentCardUsecase(this.repository);

  Future<StudentCardResponseModel> execute(
      StudentCardRequestModel request) {

    return repository.scanStudentCard(request);
  }
}