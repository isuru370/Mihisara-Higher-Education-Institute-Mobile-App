

import '../../data/models/mobile_dashboard_response_model.dart';
import '../repositories/mobile_dashboard_repository.dart';

class GetMobileDashboardUseCase {
  final MobileDashboardRepository repository;

  GetMobileDashboardUseCase(this.repository);

  Future<MobileDashboardResponseModel> call() {
    return repository.getDashboard();
  }
}
