

import '../../domain/repositories/student_classes_repository.dart';
import '../datasources/student_classes_remote_data_source.dart';
import '../models/student_classes_model/student_class_response_model.dart';
import '../models/student_classes_model/student_request_model.dart';

class StudentClassesRepositoryImpl implements StudentClassesRepository {
  final StudentClassesRemoteDataSource remote;

  StudentClassesRepositoryImpl(this.remote);

  @override
  Future<StudentClassResponseModel> getStudentClasses(
    StudentRequestModel request,
  ) {
    return remote.getStudentsClasses(request);
  }
}
