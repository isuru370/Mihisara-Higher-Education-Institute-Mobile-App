import '../../domain/repository/teacher_classes_repository.dart';
import '../datasources/teacher_classes_remote_datasource.dart';
import '../model/teacher_classes_model.dart';

class TeacherClassesRepositoryImpl
    implements TeacherClassesRepository {

  final TeacherClassesRemoteDataSource remoteDataSource;

  TeacherClassesRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<List<TeacherClassModel>> getMyClasses() async {
    return await remoteDataSource.getMyClasses();
  }
}