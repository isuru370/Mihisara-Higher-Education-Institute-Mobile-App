import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../models/login_request_model.dart';
import '../models/login_response_model.dart';

class AuthRemoteDataSource {
  Future<LoginResponseModel> login(LoginRequestModel request) async {
    try {
      final response = await http.post(
        Uri.parse(ApiConstants.login),
        headers: ApiConstants.headers(),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('LOGIN RESPONSE CODE: ${response.statusCode}');
      debugPrint('LOGIN RESPONSE BODY: ${response.body}');

      Map<String, dynamic> data = {};
      try {
        final decoded = jsonDecode(response.body);
        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (_) {}

      final serverMessage = (data['message'] ?? 'Something went wrong')
          .toString();

      if (response.statusCode == 200) {
        final result = LoginResponseModel.fromJson(data);

        await SessionStorage.saveAuth(token: result.token, user: result.user);

        return result;
      }

      if (response.statusCode == 401) {
        throw UnauthorizedException(serverMessage);
      }

      throw ServerException(serverMessage, response.statusCode);
    } on http.ClientException {
      throw NetworkException('No internet connection');
    } on FormatException {
      throw ServerException('Invalid server response', 500);
    } catch (e) {
      debugPrint('LOGIN ERROR: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    final token = await SessionStorage.getToken();
    if (token == null || token.isEmpty) return;

    try {
      await http.post(
        Uri.parse(ApiConstants.logout),
        headers: ApiConstants.headers(token: token),
      );
    } catch (e) {
      debugPrint('LOGOUT ERROR: $e');
    } finally {
      await SessionStorage.clear();
    }
  }
}
