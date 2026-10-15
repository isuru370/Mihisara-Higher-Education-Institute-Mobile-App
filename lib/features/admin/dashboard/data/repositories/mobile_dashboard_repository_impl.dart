

import '../../domain/repositories/mobile_dashboard_repository.dart';
import '../datasources/mobile_dashboard_remote_datasource.dart';
import '../models/mobile_dashboard_response_model.dart';

class MobileDashboardRepositoryImpl
    implements MobileDashboardRepository {

  final MobileDashboardRemoteDataSource remoteDataSource;

  MobileDashboardRepositoryImpl(this.remoteDataSource);

  @override
  Future<MobileDashboardResponseModel> getDashboard() async {
    return await remoteDataSource.getDashboard();
  }
}
