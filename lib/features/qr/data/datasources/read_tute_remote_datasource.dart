import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/read_tute/read_tute_response_model.dart';

class ReadTuteRemoteDataSource {
  Future<ReadTuteResponseModel> readTute({required String qrCode}) async {
    final token = await SessionStorage.getToken();

    try {
      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/student-tutes/read',
      ).replace(queryParameters: {'qr_code': qrCode});

      final response = await http
          .post(uri, headers: ApiConstants.headers(token: token))
          .timeout(const Duration(seconds: 30));

      debugPrint('GET TUTE RESPONSE CODE: ${response.statusCode}');
      debugPrint('GET TUTE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ReadTuteResponseModel.fromJson(jsonDecode(response.body));
      }

      final decoded = jsonDecode(response.body);
      throw Exception(decoded['message'] ?? 'Failed to read tute');
    } on SocketException {
      throw Exception('No internet connection');
    } on FormatException {
      throw Exception('Invalid response format');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
