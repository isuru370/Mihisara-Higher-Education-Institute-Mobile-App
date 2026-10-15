import '../../domain/repositories/read_student_classes_repository.dart';
import '../datasources/read_student_classes_remote_datasource.dart';
import '../model/read_student_classes/read_student_classes_request_model.dart';
import '../model/read_student_classes/read_student_classes_response_model.dart';

class ReadStudentClassesRepositoryImpl
    implements ReadStudentClassesRepository {
  final ReadStudentClassesRemoteDatasource remoteDatasource;

  ReadStudentClassesRepositoryImpl(this.remoteDatasource);

  @override
  Future<ReadStudentClassesResponseModel> readStudentClasses(
    ReadStudentClassesRequestModel request,
  ) async {
    return await remoteDatasource.readStudentClass(
      qrCode: request.qrCode,
    );
  }
}
