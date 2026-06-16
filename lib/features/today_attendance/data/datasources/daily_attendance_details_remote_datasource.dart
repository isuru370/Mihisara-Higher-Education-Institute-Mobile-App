import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_constants.dart';
import '../model/daily_attendance_details_request_model.dart';
import '../model/daily_attendance_details_response_model.dart';

class DailyAttendanceDetailsRemoteDataSource {
  Future<DailyAttendanceDetailsResponseModel> getDailyAttendanceDetails({
    required String token,
    required DailyAttendanceDetailsRequestModel request,
  }) async {
    final url =
        '${ApiConstants.apiUrl}/attendances/daily/'
        '${request.classId}/'
        '${request.attendanceId}/'
        '${request.classCategoryStudentClassId}/details';

    final response = await http.get(
      Uri.parse(url),
      headers: ApiConstants.headers(token: token),
    );

    if (response.statusCode == 200) {
      return DailyAttendanceDetailsResponseModel.fromJson(
        jsonDecode(response.body),
      );
    } else {
      throw Exception('Failed to load attendance details');
    }
  }
}
