import '../../data/model/teacher_students_model.dart';
import '../repository/teacher_students_repository.dart';

class GetTeacherStudents {
  final TeacherStudentsRepository repository;

  GetTeacherStudents({
    required this.repository,
  });

  Future<TeacherStudentsModel> call({
    int? classId,
  }) async {
    return await repository.getStudents(
      classId: classId,
    );
  }
}
