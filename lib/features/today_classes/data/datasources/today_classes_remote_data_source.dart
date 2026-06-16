import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';

import '../models/today_classes_response_model.dart';

class TodayClassesRemoteDataSource {
  Future<TodayClassesResponseModel> getTodayClasses() async {
    final token = await SessionStorage.getToken();

    final response = await http.get(
      Uri.parse(
        '${ApiConstants.apiUrl}/class-schedule/today-class',
      ),
      headers: ApiConstants.headers(token: token),
    );

    final jsonBody = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return TodayClassesResponseModel.fromJson(jsonBody);
    } else {
      throw Exception(
        'Failed to load today classes: ${jsonEncode(jsonBody)}',
      );
    }
  }
}