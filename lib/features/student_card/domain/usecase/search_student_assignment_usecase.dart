import '../../data/model/assignment/assignment_search_student_response_model.dart';
import '../../data/model/student_card_request_model.dart';
import '../repository/student_card_repository.dart';

class SearchStudentAssignmentUsecase {
  final StudentCardRepository repository;

  SearchStudentAssignmentUsecase(
    this.repository,
  );

  Future<AssignmentSearchStudentResponseModel> execute(
    StudentCardRequestModel request,
  ) {
    return repository.searchStudentForAssignment(
      request,
    );
  }
}