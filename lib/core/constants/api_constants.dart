class ApiConstants {
  static const String baseUrl = 'http://10.197.70.230:9000';
  static const String apiUrl = '$baseUrl/api';

  //http://10.197.70.230:9000
  //https://mihisaraeducation.nexorait.lk

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
