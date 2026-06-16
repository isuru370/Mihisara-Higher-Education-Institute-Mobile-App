import '../../domain/repository/student_image_repository.dart';

import '../datasources/student_image_remote_data_source.dart';

import '../model/student_image_response_model.dart';
import '../model/student_image_update/student_image_response_model.dart';
import '../model/student_image_update/student_image_update_request_model.dart';

class StudentImageRepositoryImpl
    implements StudentImageRepository {

  final StudentImageRemoteDataSource remoteDataSource;

  StudentImageRepositoryImpl(this.remoteDataSource);

  @override
  Future<StudentImageResponseModel> getStudentImage() {
    return remoteDataSource.getStudentImage();
  }

  @override
  Future<StudentImageUpdateResponseModel>
      updateStudentImage(
    StudentImageUpdateRequestModel request,
  ) {
    return remoteDataSource.updateStudentImage(
      request,
    );
  }
}