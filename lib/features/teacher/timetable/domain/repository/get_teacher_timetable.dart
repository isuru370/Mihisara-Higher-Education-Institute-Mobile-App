import '../../data/model/teacher_timetable_model.dart';

abstract class TeacherTimetableRepository {
  Future<TeacherTimetableModel> getTimetable({
    String? date,
  });
}