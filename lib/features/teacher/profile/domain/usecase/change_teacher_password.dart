import '../repository/teacher_profile_repository.dart';

class ChangeTeacherPassword {
  final TeacherProfileRepository repository;

  ChangeTeacherPassword({
    required this.repository,
  });

  Future<void> call({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    return await repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      newPasswordConfirmation: newPasswordConfirmation,
    );
  }
}
