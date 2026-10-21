import 'dart:convert';

import 'package:flutter/foundation.dart';
import '../../../../../core/network/api_http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/teacher_profile_model.dart';

abstract class TeacherProfileRemoteDataSource {
  /// Get teacher profile
  Future<TeacherProfileModel> getProfile();

  /// Update teacher profile
  Future<TeacherProfileModel> updateProfile({
    required Map<String, dynamic> data,
  });

  /// Change teacher password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  });
}

class TeacherProfileRemoteDataSourceImpl
    implements TeacherProfileRemoteDataSource {
  TeacherProfileRemoteDataSourceImpl();

  // ============================================================
  // GET PROFILE
  // ============================================================

  @override
  Future<TeacherProfileModel> getProfile() async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/v1/teacher/profile',
      );

      final response = await http.get(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'TEACHER PROFILE STATUS: ${response.statusCode}',
      );

      debugPrint(
        'TEACHER PROFILE RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        final data = decoded['data'];

        if (data is! Map<String, dynamic>) {
          throw Exception(
            'Invalid teacher profile data format.',
          );
        }

        final teacher = data['teacher'];

        if (teacher is! Map<String, dynamic>) {
          throw Exception(
            'Invalid teacher profile format.',
          );
        }

        return TeacherProfileModel.fromJson(teacher);
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to load teacher profile.';

      throw Exception(message);
    } on FormatException {
      throw Exception(
        'Invalid server response format.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // ============================================================
  // UPDATE PROFILE
  // ============================================================

  @override
  Future<TeacherProfileModel> updateProfile({
    required Map<String, dynamic> data,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/v1/teacher/profile',
      );

      debugPrint(
        'UPDATE TEACHER PROFILE REQUEST: $data',
      );

      final response = await http.put(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(data),
      );

      debugPrint(
        'UPDATE TEACHER PROFILE STATUS: ${response.statusCode}',
      );

      debugPrint(
        'UPDATE TEACHER PROFILE RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        final responseData = decoded['data'];

        if (responseData is! Map<String, dynamic>) {
          throw Exception(
            'Invalid teacher profile update data format.',
          );
        }

        final teacher = responseData['teacher'];

        if (teacher is! Map<String, dynamic>) {
          throw Exception(
            'Invalid teacher profile update format.',
          );
        }

        return TeacherProfileModel.fromJson(teacher);
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to update teacher profile.';

      throw Exception(message);
    } on FormatException {
      throw Exception(
        'Invalid server response format.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }

  // ============================================================
  // CHANGE PASSWORD
  // ============================================================

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/v1/teacher/profile/change-password',
      );

      final body = {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      };

      debugPrint(
        'CHANGE TEACHER PASSWORD REQUEST: $body',
      );

      final response = await http.post(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(body),
      );

      debugPrint(
        'CHANGE TEACHER PASSWORD STATUS: ${response.statusCode}',
      );

      debugPrint(
        'CHANGE TEACHER PASSWORD RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        return;
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to change password.';

      throw Exception(message);
    } on FormatException {
      throw Exception(
        'Invalid server response format.',
      );
    } on http.ClientException catch (e) {
      throw Exception(
        'Network error: ${e.message}',
      );
    } catch (e) {
      throw Exception(
        e.toString(),
      );
    }
  }
}
