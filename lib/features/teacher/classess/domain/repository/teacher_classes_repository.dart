import '../../data/model/teacher_classes_model.dart';

abstract class TeacherClassesRepository {
  Future<List<TeacherClassModel>> getMyClasses();
}