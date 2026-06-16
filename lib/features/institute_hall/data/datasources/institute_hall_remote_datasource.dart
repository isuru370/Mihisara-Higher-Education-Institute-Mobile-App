import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/institute_hall_response_model.dart';

class InstituteHallRemoteDatasource {
  Future<InstituteHallResponseModel> fetchInstituteHalls() async {
    try {
      final token = await SessionStorage.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/institute-halls'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('INSTITUTE HALL RESPONSE CODE: ${response.statusCode}');
      debugPrint('INSTITUTE HALL RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return InstituteHallResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('INSTITUTE HALL ERROR: $e');
      rethrow;
    }
  }
}
