import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/atendance_request_model.dart';
import '../models/attendance_history/attendance_history_request_model.dart';
import '../models/attendance_history/attendance_history_response_model.dart';
import '../models/attendance_response_model.dart';

class AttendanceRemoteDataSource {
  Future<AttendanceResponseModel> markAttendance({
    required AttendanceRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/attendance/store'),
      headers: {
        ...ApiConstants.headers(token: token),
        'Content-Type': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    debugPrint(response.body);

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return AttendanceResponseModel.fromJson(decoded as Map<String, dynamic>);
    }

    if (response.statusCode == 409) {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Attendance already marked for this student.';

      throw Exception(message);
    }

    final message = decoded is Map<String, dynamic>
        ? decoded['message']?.toString()
        : 'Failed to mark attendance.';

    throw Exception(message);
  }

  Future<AttendanceHistoryResponseModel> getAttendanceHistory({
    required AttendanceHistoryRequestModel request,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/attendance/students/${request.studentId}/enrollments/${request.enrollmentId}',
      );

      final response = await http.get(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
        },
      );

      debugPrint(response.body);

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AttendanceHistoryResponseModel.fromJson(
          decoded as Map<String, dynamic>,
        );
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to fetch attendance history.';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
