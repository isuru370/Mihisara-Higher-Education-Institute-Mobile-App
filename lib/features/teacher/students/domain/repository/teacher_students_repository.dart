import '../../data/model/teacher_students_model.dart';

abstract class TeacherStudentsRepository {
  Future<TeacherStudentsModel> getStudents({
    int? classId,
  });
}
