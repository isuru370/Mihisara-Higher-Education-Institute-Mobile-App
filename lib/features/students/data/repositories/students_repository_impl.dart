import '../../domain/repositories/students_repository.dart';
import '../datasources/students_remote_data_source.dart';
import '../models/create_student/create_student_response_model.dart';
import '../models/student_custom_ids/students_custom_id_request_model.dart';
import '../models/student_custom_ids/students_custom_id_response_model.dart';
import '../models/students_model.dart';
import '../models/students_model/students_response_model.dart';

class StudentRepositoryImpl implements StudentsRepository {
  final StudentRemoteDataSource remote;

  StudentRepositoryImpl(this.remote);

  @override
  Future<StudentsResponseModel> getStudents() =>
      remote.getStudents();

  @override
  Future<StudentsCustomIdResponseModel> getStudentCustomIds(
    StudentsCustomIdRequestModel request,
  ) => remote.getStudentsIds(request);

  @override
  Future<CreateStudentResponseModel> createStudent(
    StudentModel student,
  ) => remote.createStudent(student);
}
