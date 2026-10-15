import '../../data/models/mobile_dashboard_response_model.dart';

abstract class MobileDashboardRepository {
  Future<MobileDashboardResponseModel> getDashboard();
}
