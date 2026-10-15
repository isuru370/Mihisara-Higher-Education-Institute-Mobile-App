import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/teacher_classes_model.dart';

abstract class TeacherClassesRemoteDataSource {
  Future<List<TeacherClassModel>> getMyClasses();
}

class TeacherClassesRemoteDataSourceImpl
    implements TeacherClassesRemoteDataSource {

  TeacherClassesRemoteDataSourceImpl();

  @override
  Future<List<TeacherClassModel>> getMyClasses() async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.apiUrl}/v1/teacher/classes',
        ),
        headers: {
          ...ApiConstants.headers(token: token),
          'Accept': 'application/json',
        },
      );

      debugPrint(
        'TEACHER CLASSES STATUS: ${response.statusCode}',
      );

      debugPrint(
        'TEACHER CLASSES RESPONSE: ${response.body}',
      );

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          decoded is Map<String, dynamic> &&
          decoded['success'] == true) {

        final data = decoded['data'];

        if (data is! List) {
          throw Exception(
            'Invalid teacher classes data format.',
          );
        }

        return data
            .map(
              (e) => TeacherClassModel.fromJson(
                e as Map<String, dynamic>,
              ),
            )
            .toList();
      }

      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : 'Failed to load teacher classes.';

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