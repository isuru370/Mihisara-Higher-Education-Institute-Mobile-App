import 'package:nexorait_education_app/features/student_grade/data/models/student_grade_response_model.dart';
import 'package:nexorait_education_app/features/student_grade/domain/repository/student_grade_repository.dart';

class StudentGradeUsecase {
  final StudentGradeRepository repository;

  const StudentGradeUsecase(this.repository);

  Future<StudentGradeResponseModel> execute() async {
    return await repository.getStudentGrade(
    );
  }
}
