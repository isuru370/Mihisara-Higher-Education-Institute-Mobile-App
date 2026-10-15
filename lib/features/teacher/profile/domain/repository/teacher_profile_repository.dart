import '../../data/model/teacher_profile_model.dart';

abstract class TeacherProfileRepository {
  Future<TeacherProfileModel> getProfile();

  Future<TeacherProfileModel> updateProfile({
    required Map<String, dynamic> data,
  });

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}
