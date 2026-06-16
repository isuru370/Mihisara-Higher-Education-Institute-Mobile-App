import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/student_image_response_model.dart';
import '../model/student_image_update/student_image_response_model.dart';
import '../model/student_image_update/student_image_update_request_model.dart';

class StudentImageRemoteDataSource {
  // FETCH
  Future<StudentImageResponseModel> getStudentImage() async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/students-image/fetch-image'),

        headers: ApiConstants.headers(token: token),
      );

      debugPrint('STUDENT IMAGE RESPONSE CODE: ${response.statusCode}');

      debugPrint('STUDENT IMAGE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        return StudentImageResponseModel.fromJson(jsonData);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');

      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('STUDENT IMAGE ERROR: $e');

      rethrow;
    }
  }

  // UPDATE
  Future<StudentImageUpdateResponseModel> updateStudentImage(
    StudentImageUpdateRequestModel request,
  ) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/students-image/update-image'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('UPDATE IMAGE RESPONSE CODE: ${response.statusCode}');
      debugPrint('UPDATE IMAGE RESPONSE BODY: ${response.body}');

      final Map<String, dynamic> jsonData =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200) {
        return StudentImageUpdateResponseModel.fromJson(jsonData);
      }

      final message = jsonData['message']?.toString() ?? 'Request failed';

      if (response.statusCode == 404) {
        throw ServerException(message, 404);
      } else if (response.statusCode == 422) {
        throw ServerException(message, 422);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException(message);
      } else {
        throw ServerException(message, response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    }
  }
}
