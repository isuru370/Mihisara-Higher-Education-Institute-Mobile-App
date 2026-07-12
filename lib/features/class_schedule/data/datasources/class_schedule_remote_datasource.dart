import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/attendance_schedule/attendance_schedule_request_model.dart';
import '../model/attendance_schedule/attendance_schedule_response_model.dart';
import '../model/cancel/class_cancel_request_model.dart';
import '../model/cancel/class_cancel_response_model.dart';
import '../model/class_categry/class_category_request_model.dart';
import '../model/class_categry/class_category_response_model.dart';
import '../model/newday/class_new_day_request_model.dart';
import '../model/newday/class_new_day_response_model.dart';
import '../model/ongoing/ongoing_class_response_model.dart';
import '../model/schedule/class_schedule_request_model.dart';
import '../model/schedule/class_schedule_response_model.dart';
import '../model/update/update_class_schedule_request_model.dart';
import '../model/update/update_class_schedule_response_model.dart';

class ClassScheduleRemoteDatasource {
  Future<String?> _getToken() async {
    return await SessionStorage.getToken();
  }

  Future<OngoingClassResponseModel> fetchOngoingClass() async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/class-schedule/ongoing-class'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('CLASS ONGOING RESPONSE CODE: ${response.statusCode}');
      debugPrint('CLASS ONGOING RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return OngoingClassResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('CLASS ONGOING ERROR: $e');
      rethrow;
    }
  }

  Future<ClassCategoryResponseModel> fetchClassCategory(
    ClassCategoryRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.apiUrl}/class-schedule/category?class_id=${request.classId}',
        ),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('CLASS CATEGORY RESPONSE CODE: ${response.statusCode}');

      debugPrint('CLASS CATEGORY RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ClassCategoryResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');

      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('CLASS CATEGORY ERROR: $e');

      rethrow;
    }
  }

  Future<ClassScheduleResponseModel> fetchClassSchedule(
    ClassScheduleRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.get(
        Uri.parse(
          '${ApiConstants.apiUrl}/class-schedule/fetch?class_category_fee_id=${request.classCategoryFeeId}',
        ),
        headers: ApiConstants.headers(token: token),
      );

      print('CLASS SCHEDULE RESPONSE CODE: ${response.statusCode}');
      print('CLASS SCHEDULE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ClassScheduleResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('FETCH CLASS SCHEDULE ERROR: $e');
      rethrow;
    }
  }

  Future<ClassNewDayResponseModel> addNewDay(
    ClassNewDayRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/class-schedule/store'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('ADD NEW DAY RESPONSE CODE: ${response.statusCode}');
      debugPrint('ADD NEW DAY RESPONSE BODY: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ClassNewDayResponseModel.fromJson(responseData);
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Session expired. Please login again.');
      } else if (response.statusCode == 422) {
        // Validation error - extract message from response
        final errorMessage = responseData['message'] ?? 'Validation failed';
        throw ValidationException(errorMessage);
      } else {
        // Other error - use message from backend if available
        final errorMessage =
            responseData['message'] ?? 'Server error. Please try again.';
        throw ServerException(errorMessage, response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException(
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      debugPrint('ADD NEW DAY ERROR: $e');
      rethrow;
    }
  }

  Future<UpdateClassScheduleResponseModel> updateSchedule(
    UpdateClassScheduleRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.put(
        Uri.parse('${ApiConstants.apiUrl}/class-schedule/update'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('UPDATE SCHEDULE RESPONSE CODE: ${response.statusCode}');
      debugPrint('UPDATE SCHEDULE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return UpdateClassScheduleResponseModel.fromJson(
          jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('UPDATE SCHEDULE ERROR: $e');
      rethrow;
    }
  }

  Future<ClassCancelResponseModel> cancelSchedule(
    ClassCancelRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.patch(
        Uri.parse('${ApiConstants.apiUrl}/class-schedule/cancel'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('CANCEL SCHEDULE RESPONSE CODE: ${response.statusCode}');
      debugPrint('CANCEL SCHEDULE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return ClassCancelResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('CANCEL SCHEDULE ERROR: $e');
      rethrow;
    }
  }

  Future<AttendanceScheduleResponseModel> fetchAttendanceSchedules(
    AttendanceScheduleRequestModel request,
  ) async {
    try {
      final token = await _getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/attendance/schedules'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('ATTENDANCE SCHEDULE RESPONSE CODE: ${response.statusCode}');

      debugPrint('ATTENDANCE SCHEDULE RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return AttendanceScheduleResponseModel.fromJson(
          jsonDecode(response.body),
        );
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        final body = jsonDecode(response.body);

        throw ServerException(
          body['message'] ?? 'Server error',
          response.statusCode,
        );
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');

      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('ATTENDANCE SCHEDULE ERROR: $e');

      rethrow;
    }
  }
}
