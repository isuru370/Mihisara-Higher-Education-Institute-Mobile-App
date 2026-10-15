import '../../domain/repository/get_teacher_timetable.dart';
import '../datasource/teacher_timetable_remote_datasource.dart';
import '../model/teacher_timetable_model.dart';

class TeacherTimetableRepositoryImpl
    implements TeacherTimetableRepository {
  final TeacherTimetableRemoteDataSource remoteDataSource;

  TeacherTimetableRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TeacherTimetableModel> getTimetable({
    String? date,
  }) async {
    return await remoteDataSource.getTimetable(
      date: date,
    );
  }
}