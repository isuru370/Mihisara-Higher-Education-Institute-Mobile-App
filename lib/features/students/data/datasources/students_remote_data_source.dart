import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/create_student/create_student_response_model.dart';
import '../models/student_custom_ids/students_custom_id_request_model.dart';
import '../models/student_custom_ids/students_custom_id_response_model.dart';
import '../models/students_model.dart';
import '../models/students_model/students_response_model.dart';

class StudentRemoteDataSource {
  Future<StudentsResponseModel> getStudents() async {
    try {
      final token = await SessionStorage.getToken();
      final uri = Uri.parse('${ApiConstants.apiUrl}/students');

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('GET STUDENTS RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENTS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentsResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<List<StudentModel>> searchStudent(String studentCustomId) async {
    try {
      final token = await SessionStorage.getToken();
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/students/search/$studentCustomId',
      );
      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('GET STUDENTS RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET STUDENTS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> decoded = jsonDecode(response.body);
        final List<dynamic> studentsJson = decoded['data'];

        return studentsJson.map((json) => StudentModel.fromJson(json)).toList();
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized: Invalid token');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('STUDENTS FETCH ERROR: $e');
      rethrow; // let Bloc handle it
    }
  }

  Future<StudentsCustomIdResponseModel> getStudentsIds(
    StudentsCustomIdRequestModel request,
  ) async {
    try {
      final token = await SessionStorage.getToken();
      final uri = Uri.parse('${ApiConstants.apiUrl}/students/custom_ids')
          .replace(
            queryParameters: {
              if (request.search != null) 'search': request.search,
              if (request.month != null) 'month': request.month,
            },
          );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      debugPrint(
        'GET STUDENTS CUSTOM IDS RESPONSE CODE: ${response.statusCode}',
      );
      debugPrint('GET STUDENTS CUSTOM IDS RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        return StudentsCustomIdResponseModel.fromJson(decoded);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<CreateStudentResponseModel> createStudent(StudentModel student) async {
    try {
      final token = await SessionStorage.getToken();
      final uri = Uri.parse('${ApiConstants.apiUrl}/student');

      final response = await http.post(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(student.toJson()),
      );

      debugPrint('CREATE STUDENT RESPONSE CODE: ${response.statusCode}');
      debugPrint('CREATE STUDENT RESPONSE BODY: ${response.body}');

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 201) {
        return CreateStudentResponseModel.fromJson(
          decoded as Map<String, dynamic>,
        );
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      }

      if (decoded is Map<String, dynamic> && decoded['message'] != null) {
        throw ServerException(
          decoded['message'].toString(),
          response.statusCode,
        );
      }

      throw ServerException('Server Error', response.statusCode);
    } catch (e) {
      debugPrint('CREATE STUDENT ERROR: $e');
      rethrow;
    }
  }
}
