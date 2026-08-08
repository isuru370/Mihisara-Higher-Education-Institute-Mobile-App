import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/assignment/assignment_card_request_model.dart';
import '../model/assignment/assignment_card_response_model.dart';
import '../model/assignment/assignment_search_student_response_model.dart';
import '../model/re_assign/re_assign_request_model.dart';
import '../model/re_assign/re_assign_response_model.dart';
import '../model/student_card_request_model.dart';
import '../model/student_card_response_model.dart';

class StudentCardRemoteDataSource {
  const StudentCardRemoteDataSource();

  Future<StudentCardResponseModel> scanStudentCard({
    required StudentCardRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/qr-code'),
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestModel.toJson()),
      );

      final Map<String, dynamic> jsonBody =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return StudentCardResponseModel.fromJson(jsonBody);
      }

      final message =
          jsonBody['message']?.toString() ?? 'Failed to scan student card';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<ReAssignResponseModel> reAssignStudentCard({
    required ReAssignRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/re-assign'),
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestModel.toJson()),
      );

      final Map<String, dynamic> jsonBody =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ReAssignResponseModel.fromJson(jsonBody);
      }

      final message =
          jsonBody['message']?.toString() ?? 'Failed to reassign student card';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AssignmentSearchStudentResponseModel> searchStudentForAssignment({
    required StudentCardRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse(
          '${ApiConstants.apiUrl}/student-card-assignment/search-student',
        ),
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestModel.toAssignmentJson()),
      );

      final Map<String, dynamic> jsonBody =
          jsonDecode(response.body) as Map<String, dynamic>;

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssignmentSearchStudentResponseModel.fromJson(jsonBody);
      }

      throw Exception(
        jsonBody['message']?.toString() ?? 'Failed to search student.',
      );
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<AssignmentCardResponseModel> assignStudentCard({
    required AssignmentCardRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/student-card-assignment/assign'),
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(requestModel.toJson()),
      );

      debugPrint('STATUS : ${response.statusCode}');
      debugPrint('BODY : ${response.body}');

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return AssignmentCardResponseModel.fromJson(jsonBody);
      }

      throw Exception(jsonBody['message'] ?? 'Failed to assign student card.');
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
