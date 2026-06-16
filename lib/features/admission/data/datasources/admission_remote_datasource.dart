import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/app_exceptions.dart';
import '../../../../core/storage/session_storage.dart';
import '../../../students/data/models/create_student/create_student_response_model.dart';
import '../model/admission/admission_response_model.dart';
import '../model/payment/admission_payment_response_model.dart';
import '../model/store/admission_payment_request_model.dart';

class AdmissionRemoteDatasource {
  Future<AdmissionResponseModel> fetchAdmissionData() async {
    try {
      final token = await SessionStorage.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/admission'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('ADMISSION RESPONSE CODE: ${response.statusCode}');
      debugPrint('ADMISSION RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return AdmissionResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException catch (e) {
      debugPrint('NETWORK ERROR: $e');
      throw NetworkException('No internet connection');
    } catch (e) {
      debugPrint('ADMISSION ERROR: $e');
      rethrow;
    }
  }

  Future<AdmissionPaymentResponseModel> fetchAdmissionPaymentData() async {
    try {
      final token = await SessionStorage.getToken();
      final response = await http.get(
        Uri.parse('${ApiConstants.apiUrl}/admission-payments'),
        headers: ApiConstants.headers(token: token),
      );

      debugPrint('ADMISSION PAYMENT RESPONSE CODE: ${response.statusCode}');
      debugPrint('ADMISSION PAYMENT RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200) {
        return AdmissionPaymentResponseModel.fromJson(
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
      debugPrint('ADMISSION PAYMENT ERROR: $e');
      rethrow;
    }
  }

  Future<CreateStudentResponseModel> storeAdmissionPayment(
    AdmissionPaymentRequestModel request,
  ) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/admission-payments/store'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(request.toJson()),
      );

      debugPrint('STORE ADMISSION RESPONSE CODE: ${response.statusCode}');

      debugPrint('STORE ADMISSION RESPONSE BODY: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return CreateStudentResponseModel.fromJson(jsonDecode(response.body));
      } else if (response.statusCode == 401) {
        throw UnauthorizedException('Unauthorized');
      } else {
        throw ServerException('Server error', response.statusCode);
      }
    } on http.ClientException {
      throw NetworkException('No internet connection');
    }
  }
}
