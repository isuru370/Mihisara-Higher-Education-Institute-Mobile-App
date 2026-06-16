import '../../domain/repository/student_class_repository.dart';
import '../datasources/student_class_remote_datasource.dart';
import '../models/get_class_with_grade_model/get_classes_by_grade_request_model.dart';
import '../models/get_class_with_grade_model/get_classes_by_grade_response_model.dart';
import '../models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../models/store_student_class_enrollment/create_student_response_class_model.dart';
import '../models/student_class_enrollment_status_change_model/class_status_request_model.dart';
import '../models/student_class_enrollment_status_change_model/class_status_response_model.dart';


class StudentClassRepositoryImpl implements StudentClassRepository {
  final StudentClassRemoteDatasource remoteDatasource;

  StudentClassRepositoryImpl(
     this.remoteDatasource,
  );

  @override
  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required String gradeId,
  }) async {
    final request = GetClassesByGradeRequestModel(
      gradeId: gradeId,
    );

    return await remoteDatasource.getClassesByGrade(
      request: request,
    );
  }

  @override
  Future<CreateStudentClassResponseModel> createStudentClassEnrollment({
    required CreateStudentClassRequestModel request,
  }) async {
    return await remoteDatasource.createStudentClassEnrollment(
      request: request,
    );
  }

  @override
  Future<ClassStatusResponseModel> toggleClassStatus({
    required ClassStatusRequestModel request,
  }) {
    return remoteDatasource.toggleClassStatus(request: request);
  }
}