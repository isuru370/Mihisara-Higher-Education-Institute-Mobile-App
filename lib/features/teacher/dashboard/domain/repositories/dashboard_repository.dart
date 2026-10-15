import '../../data/models/teacher_dashboard_model.dart';

abstract class DashboardRepository {
  Future<TeacherDashboardModel> getTeacherDashboard();
}
