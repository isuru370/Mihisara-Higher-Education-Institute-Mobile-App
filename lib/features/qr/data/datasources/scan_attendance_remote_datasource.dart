import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/scan_attendance_new/scan_attendance_request_model.dart';
import '../model/scan_attendance_new/scan_attendance_response_model.dart';

class ScanAttendanceRemoteDatasource {
  Future<ScanAttendanceResponseModel> readAttendance({
    required ScanAttendanceRequestModel requestModel,
  }) async {
    final token = await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/attendance/scan'),

      headers: ApiConstants.headers(token: token),

      body: jsonEncode(requestModel.toJson()),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ScanAttendanceResponseModel.fromJson(jsonBody);
    } else {
      throw Exception(jsonBody['message'] ?? 'Failed to scan attendance');
    }
  }
}
