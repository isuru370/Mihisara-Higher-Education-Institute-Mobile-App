import '../../domain/repository/teacher_profile_repository.dart';
import '../datasources/teacher_profile_remote_datasource.dart';
import '../model/teacher_profile_model.dart';

class TeacherProfileRepositoryImpl
    implements TeacherProfileRepository {
  final TeacherProfileRemoteDataSource remoteDataSource;

  TeacherProfileRepositoryImpl({
    required this.remoteDataSource,
  });

  @override
  Future<TeacherProfileModel> getProfile() async {
    try {
      return await remoteDataSource.getProfile();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<TeacherProfileModel> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      return await remoteDataSource.updateProfile(
        data: data,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      await remoteDataSource.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
        newPasswordConfirmation: newPasswordConfirmation,
      );
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}