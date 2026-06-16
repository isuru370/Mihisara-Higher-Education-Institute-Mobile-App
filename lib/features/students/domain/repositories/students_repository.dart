import '../../data/models/create_student/create_student_response_model.dart';
import '../../data/models/student_custom_ids/students_custom_id_request_model.dart';
import '../../data/models/student_custom_ids/students_custom_id_response_model.dart';
import '../../data/models/students_model.dart';
import '../../data/models/students_model/students_response_model.dart';

abstract class StudentsRepository {
  Future<StudentsResponseModel> getStudents();
  Future<StudentsCustomIdResponseModel> getStudentCustomIds(
    StudentsCustomIdRequestModel request,
  );
  Future<CreateStudentResponseModel> createStudent(
    StudentModel student,
  );
}
