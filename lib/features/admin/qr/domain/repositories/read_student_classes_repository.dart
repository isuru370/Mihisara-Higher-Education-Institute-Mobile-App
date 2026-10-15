import '../../data/model/read_student_classes/read_student_classes_request_model.dart';
import '../../data/model/read_student_classes/read_student_classes_response_model.dart';

abstract class ReadStudentClassesRepository {

  Future<ReadStudentClassesResponseModel> readStudentClasses(
    ReadStudentClassesRequestModel request,
  );

}