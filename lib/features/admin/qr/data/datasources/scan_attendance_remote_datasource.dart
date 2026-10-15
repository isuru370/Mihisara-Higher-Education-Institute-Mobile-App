import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/scan_attendance_new/scan_attendance_request_model.dart';
import '../model/scan_attendance_new/scan_attendance_response_model.dart';

class ScanAttendanceRemoteDatasource {
  Future<ScanAttendanceResponseModel> readAttendance({
    required ScanAttendanceRequestModel requestModel,
  }) async {
    final token = await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/new-attendance/scan'),
      headers: ApiConstants.headers(token: token),
      body: jsonEncode(requestModel.toJson()),
    );

    debugPrint('ATTENDANCE STATUS: ${response.statusCode}');

    debugPrint('ATTENDANCE BODY: ${response.body}');

    dynamic decodedBody;

    try {
      decodedBody = jsonDecode(response.body);
    } catch (e) {
      throw Exception('Invalid response received from attendance server.');
    }

    if (response.statusCode == 200 || response.statusCode == 201) {
      return ScanAttendanceResponseModel.fromJson(
        decodedBody as Map<String, dynamic>,
      );
    }

    final message = decodedBody is Map<String, dynamic>
        ? decodedBody['message']?.toString()
        : null;

    throw Exception(message ?? 'Failed to scan attendance.');
  }
}
