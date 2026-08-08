import '../../domain/repository/student_card_repository.dart';
import '../datasources/student_card_remote_data_source.dart';
import '../model/assignment/assignment_card_request_model.dart';
import '../model/assignment/assignment_card_response_model.dart';
import '../model/assignment/assignment_search_student_response_model.dart';
import '../model/re_assign/re_assign_request_model.dart';
import '../model/re_assign/re_assign_response_model.dart';
import '../model/student_card_request_model.dart';
import '../model/student_card_response_model.dart';

class StudentCardRepositoryImpl implements StudentCardRepository {
  final StudentCardRemoteDataSource remote;

  StudentCardRepositoryImpl(this.remote);

  @override
  Future<StudentCardResponseModel> scanStudentCard(
    StudentCardRequestModel request,
  ) {
    return remote.scanStudentCard(requestModel: request);
  }

  @override
  Future<ReAssignResponseModel> reAssignCard(ReAssignRequestModel request) {
    return remote.reAssignStudentCard(requestModel: request);
  }

  @override
  Future<AssignmentSearchStudentResponseModel>
      searchStudentForAssignment(
    StudentCardRequestModel request,
  ) {
    return remote.searchStudentForAssignment(
      requestModel: request,
    );
  }
  @override
Future<AssignmentCardResponseModel> assignStudentCard(
  AssignmentCardRequestModel request,
) {
  return remote.assignStudentCard(
    requestModel: request,
  );
}
}
