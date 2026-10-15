import '../../data/model/teacher_profile_model.dart';
import '../repository/teacher_profile_repository.dart';

class UpdateTeacherProfile {
  final TeacherProfileRepository repository;

  UpdateTeacherProfile({
    required this.repository,
  });

  Future<TeacherProfileModel> call({
    required Map<String, dynamic> data,
  }) async {
    return await repository.updateProfile(
      data: data,
    );
  }
}
