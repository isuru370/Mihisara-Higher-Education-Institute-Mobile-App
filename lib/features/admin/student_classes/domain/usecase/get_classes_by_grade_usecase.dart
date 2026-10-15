import '../../data/models/get_class_with_grade_model/get_classes_by_grade_response_model.dart';
import '../repository/student_class_repository.dart';

class GetClassesByGradeUseCase {
  final StudentClassRepository repository;

  GetClassesByGradeUseCase(
     this.repository,
  );

  Future<GetClassesByGradeResponseModel> call({
    required String gradeId,
  }) {
    return repository.getClassesByGrade(
      gradeId: gradeId,
    );
  }
}