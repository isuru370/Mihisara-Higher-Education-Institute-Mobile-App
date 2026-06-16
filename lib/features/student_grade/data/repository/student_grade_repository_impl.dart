import 'package:nexorait_education_app/features/student_grade/data/datasources/student_grade_remote_datasource.dart';
import 'package:nexorait_education_app/features/student_grade/data/models/student_grade_response_model.dart';
import 'package:nexorait_education_app/features/student_grade/domain/repository/student_grade_repository.dart';

class StudentGradeRepositoryImpl implements StudentGradeRepository {
  final StudentGradeRemoteDatasource remote;

  const StudentGradeRepositoryImpl(this.remote);

  @override
  Future<StudentGradeResponseModel> getStudentGrade(
  ) {
    return remote.getStudentGrades(

    );
  }
}
