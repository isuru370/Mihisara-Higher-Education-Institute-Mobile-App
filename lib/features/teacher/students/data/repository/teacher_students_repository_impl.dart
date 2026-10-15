import '../../domain/repository/teacher_students_repository.dart';
import '../datasource/teacher_students_remote_datasource.dart';
import '../model/teacher_students_model.dart';

class TeacherStudentsRepositoryImpl
    implements TeacherStudentsRepository {
  final TeacherStudentsRemoteDataSource remoteDataSource;

  TeacherStudentsRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TeacherStudentsModel> getStudents({
    int? classId,
  }) async {
    try {
      return await remoteDataSource.getStudents(
        classId: classId,
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
