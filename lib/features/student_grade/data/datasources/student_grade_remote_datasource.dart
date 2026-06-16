import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/student_grade_response_model.dart';

class StudentGradeRemoteDatasource {
  Future<StudentGradeResponseModel> getStudentGrades() async {
    try {
      final token = await SessionStorage.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/grades'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('STUDENT GRADE RESPONSE CODE: ${response.statusCode}');
      debugPrint('STUDENT GRADE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return StudentGradeResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('STUDENT GRADE ERROR: $e');
      rethrow;
    }
  }
}
