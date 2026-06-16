import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';

import '../model/read_attendance/read_attendance_request_model.dart';
import '../model/read_attendance/read_attendance_response_model.dart';

class ReadAttendanceRemoteDatasource {

  Future<ReadAttendanceResponseModel>
  readAttendance({
    required ReadAttendanceRequestModel requestModel,
  }) async {

    final token =
        await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse(
        '${ApiConstants.apiUrl}/attendance/read',
      ),

      headers: ApiConstants.headers(
        token: token,
      ),

      body: jsonEncode(
        requestModel.toJson(),
      ),
    );

    final jsonBody =
        jsonDecode(response.body);

    if (response.statusCode == 200) {

      return ReadAttendanceResponseModel
          .fromJson(jsonBody);

    } else {

      throw Exception(
        jsonBody['message'] ??
            'Failed to read attendance',
      );
    }
  }
}