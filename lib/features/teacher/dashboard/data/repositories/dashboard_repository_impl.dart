import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/teacher_dashboard_remote_datasource.dart';
import '../models/teacher_dashboard_model.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final TeacherDashboardRemoteDataSource remoteDataSource;

  DashboardRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TeacherDashboardModel> getTeacherDashboard() async {
    return await remoteDataSource.getTeacherDashboard();
  }
}
