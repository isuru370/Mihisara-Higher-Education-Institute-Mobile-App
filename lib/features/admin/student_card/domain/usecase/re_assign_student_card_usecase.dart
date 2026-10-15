import '../../data/model/re_assign/re_assign_request_model.dart';
import '../../data/model/re_assign/re_assign_response_model.dart';
import '../repository/student_card_repository.dart';

class ReAssignStudentCardUsecase {
  final StudentCardRepository repository;

  ReAssignStudentCardUsecase(this.repository);

  Future<ReAssignResponseModel> execute(ReAssignRequestModel request) {
    return repository.reAssignCard(request);
  }
}
