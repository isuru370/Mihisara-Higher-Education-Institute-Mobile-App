import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/teacher_timetable_model.dart';

abstract class TeacherTimetableRemoteDataSource {
  Future<TeacherTimetableModel> getTimetable({String? date});
}

class TeacherTimetableRemoteDataSourceImpl
    implements TeacherTimetableRemoteDataSource {
  TeacherTimetableRemoteDataSourceImpl();

  @override
  Future<TeacherTimetableModel> getTimetable({String? date}) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse('${ApiConstants.apiUrl}/v1/teacher/timetable')
          .replace(
            queryParameters: date != null && date.isNotEmpty
                ? {'date': date}
                : null,
          );

      debugPrint('TEACHER TIMETABLE URL: $uri');

      final response = await http.get(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
        },
      );

      debugPrint('TEACHER TIMETABLE STATUS: ${response.statusCode}');

      debugPrint('TEACHER TIMETABLE RESPONSE: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {
        final data = decoded['data'];

        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid teacher timetable data format.');
        }

        return TeacherTimetableModel.fromJson(data);
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to load teacher timetable.';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format.');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
