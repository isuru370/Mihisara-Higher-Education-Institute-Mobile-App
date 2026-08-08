import '../../data/model/assignment/assignment_card_request_model.dart';
import '../../data/model/assignment/assignment_card_response_model.dart';
import '../../data/model/assignment/assignment_search_student_response_model.dart';
import '../../data/model/re_assign/re_assign_request_model.dart';
import '../../data/model/re_assign/re_assign_response_model.dart';
import '../../data/model/student_card_request_model.dart';
import '../../data/model/student_card_response_model.dart';

abstract class StudentCardRepository {
  Future<StudentCardResponseModel> scanStudentCard(
    StudentCardRequestModel request,
  );
  Future<ReAssignResponseModel> reAssignCard(
    ReAssignRequestModel request,
  );
 Future<AssignmentSearchStudentResponseModel>
      searchStudentForAssignment(
    StudentCardRequestModel request,
  );
  Future<AssignmentCardResponseModel> assignStudentCard(
  AssignmentCardRequestModel request,
);
}