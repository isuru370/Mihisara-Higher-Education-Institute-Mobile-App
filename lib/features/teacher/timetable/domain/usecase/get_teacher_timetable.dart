import '../../data/model/teacher_timetable_model.dart';
import '../repository/get_teacher_timetable.dart';

class GetTeacherTimetable {
  final TeacherTimetableRepository repository;

  GetTeacherTimetable({
    required this.repository,
  });

  Future<TeacherTimetableModel> call({
    String? date,
  }) async {
    return await repository.getTimetable(
      date: date,
    );
  }
}