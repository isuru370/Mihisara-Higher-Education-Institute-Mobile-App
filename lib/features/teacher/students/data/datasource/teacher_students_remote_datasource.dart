import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/teacher_students_model.dart';

abstract class TeacherStudentsRemoteDataSource {
  Future<TeacherStudentsModel> getStudents({
    int? classId,
  });
}

class TeacherStudentsRemoteDataSourceImpl
    implements TeacherStudentsRemoteDataSource {
  TeacherStudentsRemoteDataSourceImpl();

  @override
  Future<TeacherStudentsModel> getStudents({
    int? classId,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/v1/teacher/students',
      ).replace(
        queryParameters: classId != null
            ? {
                'class_id': classId.toString(),
              }
            : null,
      );

      final response = await http.get(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'TEACHER STUDENTS STATUS: ${response.statusCode}',
      );

      debugPrint(
        'TEACHER STUDENTS RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        final data = decoded['data'];

        if (data is! Map<String, dynamic>) {
          throw Exception(
            'Invalid teacher students data format.',
          );
        }

        return TeacherStudentsModel.fromJson(data);
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to load teacher students.';

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
