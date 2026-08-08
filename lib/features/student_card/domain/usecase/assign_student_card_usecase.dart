import '../../data/model/assignment/assignment_card_request_model.dart';
import '../../data/model/assignment/assignment_card_response_model.dart';
import '../repository/student_card_repository.dart';

class AssignStudentCardUsecase {
  final StudentCardRepository repository;

  AssignStudentCardUsecase(
    this.repository,
  );

  Future<AssignmentCardResponseModel> execute(
    AssignmentCardRequestModel request,
  ) {
    return repository.assignStudentCard(
      request,
    );
  }
}