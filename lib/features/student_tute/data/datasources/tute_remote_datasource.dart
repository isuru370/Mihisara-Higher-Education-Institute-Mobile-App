import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/create_tute/create__tute_response_model.dart';
import '../model/create_tute/create_tute_request_model.dart';
import '../model/fetch_tute/fetch_tute_response_model.dart';

class TuteRemoteDataSource {
  Future<CreateStudentTuteResponseModel> createStudentTute({
    required CreateTuteRequestModel request,
  }) async {
    final token = await SessionStorage.getToken();

    try {
      final uri = Uri.parse('${ApiConstants.apiUrl}/student-tutes/store');

      final response = await http.post(
        uri,
        headers: {
          ...ApiConstants.headers(token: token),
          'Content-Type': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final decoded = jsonDecode(response.body);
        return CreateStudentTuteResponseModel.fromJson(decoded);
      }

      final decoded = jsonDecode(response.body);
      throw Exception(
        decoded['message'] ?? 'Server error: ${response.statusCode}',
      );
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  Future<FetchStudentTuteResponseModel> getStudentTuteHistory({
    required int studentId,
    required int enrolledId,
  }) async {
    final token = await SessionStorage.getToken();

    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/student-tutes/students/$studentId/enrollments/$enrolledId',
      );

      final response = await http
          .get(uri, headers: ApiConstants.headers(token: token))
          .timeout(const Duration(seconds: 30));

      debugPrint('GET TUTE HISTORY STATUS: ${response.statusCode}');
      debugPrint('GET TUTE HISTORY BODY: ${response.body}');

      if (response.body.isEmpty) {
        throw Exception('Empty response from server');
      }

      final decoded = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return FetchStudentTuteResponseModel.fromJson(decoded);
      }

      throw Exception(
        decoded['message'] ?? 'Server error: ${response.statusCode}',
      );
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }
}
