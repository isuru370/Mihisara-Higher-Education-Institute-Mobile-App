import '../../../data/models/teacher_dashboard_model.dart';
import '../dashboard_repository.dart';


class GetTeacherDashboard {
  final DashboardRepository repository;

  GetTeacherDashboard({
    required this.repository,
  });

  Future<TeacherDashboardModel> call(

  ) async {
    return await repository.getTeacherDashboard();
  }
}