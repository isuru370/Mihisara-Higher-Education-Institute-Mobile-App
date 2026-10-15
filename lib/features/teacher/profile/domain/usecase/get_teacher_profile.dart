import '../../data/model/teacher_profile_model.dart';
import '../repository/teacher_profile_repository.dart';

class GetTeacherProfile {
  final TeacherProfileRepository repository;

  GetTeacherProfile({
    required this.repository,
  });

  Future<TeacherProfileModel> call() async {
    return await repository.getProfile();
  }
}
