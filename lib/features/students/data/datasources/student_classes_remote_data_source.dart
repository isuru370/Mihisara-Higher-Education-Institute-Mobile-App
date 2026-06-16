import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_class_response_model.dart';
import 'package:nexorait_education_app/features/students/data/models/student_classes_model/student_request_model.dart';

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';

class StudentClassesRemoteDataSource {
  Future<StudentClassResponseModel> getStudentsClasses(
    StudentRequestModel request,
  ) async {
    try {
      final token = await SessionStorage.getToken();
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/student-class-enrollments/${request.studentId}',
      );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('GET STUDENT CLASSES RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENT CLASSES RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentClassResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e, stackTrace) {
      debugPrint('STUDENT CLASSES FETCH ERROR: $e');
      debugPrint('STACK TRACE: $stackTrace');
      rethrow;
    }
  }
}
