import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/read_student_classes/read_student_classes_response_model.dart';

class ReadStudentClassesRemoteDatasource {
  Future<ReadStudentClassesResponseModel> readStudentClass({
    required String qrCode,
  }) async {
    final token = await SessionStorage.getToken();

    final uri = Uri.parse(
      '${ApiConstants.apiUrl}/student-class-enrollments/read-student-class',
    );

    final response = await http.post(
      uri,
      headers: ApiConstants.headers(token: token),
      body: jsonEncode({'qr_code': qrCode}),
    );

    debugPrint('Status code: ${response.statusCode}');
    debugPrint('Response body: ${response.body}');

    final decoded = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return ReadStudentClassesResponseModel.fromJson(
        decoded is Map<String, dynamic> ? decoded : <String, dynamic>{},
      );
    } else {
      final message = decoded is Map<String, dynamic>
          ? decoded['message']?.toString()
          : null;

      throw Exception(
        message ?? 'Failed to read student: ${response.statusCode}',
      );
    }
  }
}
