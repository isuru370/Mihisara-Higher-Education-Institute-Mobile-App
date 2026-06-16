import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/get_class_with_grade_model/get_classes_by_grade_request_model.dart';
import '../models/get_class_with_grade_model/get_classes_by_grade_response_model.dart';
import '../models/store_student_class_enrollment/create_student_request_class_model.dart';
import '../models/store_student_class_enrollment/create_student_response_class_model.dart';
import '../models/student_class_enrollment_status_change_model/class_status_request_model.dart';
import '../models/student_class_enrollment_status_change_model/class_status_response_model.dart';

class StudentClassRemoteDatasource {
  Future<GetClassesByGradeResponseModel> getClassesByGrade({
    required GetClassesByGradeRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();

    try {
      final url = '${ApiConstants.apiUrl}/student-classes/${request.gradeId}';

      final response = await http.get(
        Uri.parse(url),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return GetClassesByGradeResponseModel.fromJson(
          decoded as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          'Failed to fetch classes. Status: ${response.statusCode}, Body: ${response.body}',
        );
      }
    } catch (e, s) {
      debugPrint('GET CLASSES ERROR: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }

  Future<CreateStudentClassResponseModel> createStudentClassEnrollment({
    required CreateStudentClassRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();

    try {
      final url = '${ApiConstants.apiUrl}/student-class-enrollments';

      final response = await http.post(
        Uri.parse(url),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        return CreateStudentClassResponseModel.fromJson(
          decoded as Map<String, dynamic>,
        );
      } else if (response.statusCode == 422) {
        final message = decoded['message']?.toString() ?? 'Validation failed';
        throw Exception(message);
      } else {
        throw Exception(
          decoded['message']?.toString() ??
              'Failed to create enrollment. Status: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      debugPrint('CREATE ENROLLMENT ERROR: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }

  Future<ClassStatusResponseModel> toggleClassStatus({
    required ClassStatusRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();

    try {
      final url =
          '${ApiConstants.apiUrl}/student-class-enrollments/toggle-status/${request.studentEnrollmentId}';

      final response = await http.patch(
        Uri.parse(url),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('STATUS CODE: ${response.statusCode}');
      debugPrint('RESPONSE BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ClassStatusResponseModel.fromJson(
          decoded as Map<String, dynamic>,
        );
      } else {
        throw Exception(
          decoded['message']?.toString() ??
              'Failed to change class status. Status: ${response.statusCode}',
        );
      }
    } catch (e, s) {
      debugPrint('TOGGLE CLASS STATUS ERROR: $e');
      debugPrint('STACKTRACE: $s');
      rethrow;
    }
  }
}