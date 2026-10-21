import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../models/teacher_dashboard_model.dart';

abstract class TeacherDashboardRemoteDataSource {
  Future<TeacherDashboardModel> getTeacherDashboard();
}

class TeacherDashboardRemoteDataSourceImpl
    implements TeacherDashboardRemoteDataSource {
  TeacherDashboardRemoteDataSourceImpl();

  @override
  Future<TeacherDashboardModel> getTeacherDashboard() async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.apiUrl}/v1/teacher/dashboard',
        ),
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'TEACHER DASHBOARD STATUS: ${response.statusCode}',
      );

      debugPrint(
        'TEACHER DASHBOARD RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        return TeacherDashboardModel.fromJson(
          decoded['data'] as Map<String, dynamic>,
        );
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to load teacher dashboard.';

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