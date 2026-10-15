import '../../data/models/student_grade_response_model.dart';

abstract class StudentGradeRepository {
  Future<StudentGradeResponseModel> getStudentGrade(
  );
}
