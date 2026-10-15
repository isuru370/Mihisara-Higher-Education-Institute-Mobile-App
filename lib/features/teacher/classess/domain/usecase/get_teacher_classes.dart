import '../../data/model/teacher_classes_model.dart';
import '../repository/teacher_classes_repository.dart';

class GetTeacherClasses {
  final TeacherClassesRepository repository;

  GetTeacherClasses({
    required this.repository,
  });

  Future<List<TeacherClassModel>> call() async {
    return await repository.getMyClasses();
  }
}