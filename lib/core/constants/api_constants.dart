import 'package:flutter/foundation.dart';

class ApiConstants {
  /// Live server, used by release builds (APK / app bundle).
  static const String productionBaseUrl = 'https://mihisaraeducation.nexorait.lk';

  /// Local development server, used by debug builds (`flutter run`).
  static const String developmentBaseUrl = 'http://192.168.141.230:8000';

  /// Release builds talk to production, debug builds to the local server.
  /// Override either with:
  ///   flutter run --dart-define=API_BASE_URL=http://10.239.47.230:8000
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: kReleaseMode ? productionBaseUrl : developmentBaseUrl,
  );

  static const String apiUrl = '$baseUrl/api';

  static const String login = '$apiUrl/login';
  static const String logout = '$apiUrl/logout';
  static const String profile = '$apiUrl/profile';

  static const String contentType = 'Content-Type';
  static const String accept = 'Accept';
  static const String authorization = 'Authorization';

  static const String applicationJson = 'application/json; charset=UTF-8';

  static Map<String, String> headers({String? token}) {
    final headers = <String, String>{
      contentType: applicationJson,
      accept: 'application/json',
    };

    if (token != null && token.isNotEmpty) {
      headers[authorization] = 'Bearer $token';
    }

    return headers;
  }
}
