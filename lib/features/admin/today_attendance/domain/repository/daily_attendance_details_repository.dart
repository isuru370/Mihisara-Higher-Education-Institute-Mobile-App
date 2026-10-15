import '../../data/model/daily_attendance_details_request_model.dart';
import '../../data/model/daily_attendance_details_response_model.dart';

abstract class DailyAttendanceDetailsRepository {
  Future<DailyAttendanceDetailsResponseModel> getDailyAttendanceDetails({
    required String token,
    required DailyAttendanceDetailsRequestModel request,
  });
}
