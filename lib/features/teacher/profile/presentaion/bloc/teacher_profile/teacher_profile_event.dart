part of 'teacher_profile_bloc.dart';

sealed class TeacherProfileEvent extends Equatable {
  const TeacherProfileEvent();

  @override
  List<Object?> get props => [];
}

/// Fetch teacher profile
final class FetchTeacherProfile extends TeacherProfileEvent {
  const FetchTeacherProfile();
}

/// Update teacher profile
final class UpdateTeacherProfile extends TeacherProfileEvent {
  final Map<String, dynamic> data;

  const UpdateTeacherProfile({
    required this.data,
  });

  @override
  List<Object?> get props => [data];
}

/// Change teacher password
final class ChangeTeacherPassword extends TeacherProfileEvent {
  final String currentPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const ChangeTeacherPassword({
    required this.currentPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  List<Object?> get props => [
        currentPassword,
        newPassword,
        newPasswordConfirmation,
      ];
}