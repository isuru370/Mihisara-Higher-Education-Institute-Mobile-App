import '../../data/model/daily_attendance_details_request_model.dart';
import '../../data/model/daily_attendance_details_response_model.dart';
import '../repository/daily_attendance_details_repository.dart';

class GetDailyAttendanceDetailsUseCase {
  final DailyAttendanceDetailsRepository repository;

  GetDailyAttendanceDetailsUseCase(this.repository);

  Future<DailyAttendanceDetailsResponseModel> call({
    required String token,
    required DailyAttendanceDetailsRequestModel request,
  }) {
    return repository.getDailyAttendanceDetails(token: token, request: request);
  }
}
