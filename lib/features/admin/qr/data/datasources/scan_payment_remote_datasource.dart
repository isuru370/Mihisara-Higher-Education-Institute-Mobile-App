import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../model/scan_payment_new/scan_payment_request_model.dart';
import '../model/scan_payment_new/scan_payment_response_model.dart';

class ScanPaymentRemoteDatasource {
  Future<ScanPaymentResponseModel> readPayment({
    required ScanPaymentRequestModel requestModel,
  }) async {
    final token = await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/new-payment/read'),
      headers: ApiConstants.headers(token: token),
      body: jsonEncode(
        requestModel.toJson(),
      ),
    );

    debugPrint(
      'PAYMENT SCAN STATUS: ${response.statusCode}',
    );

    debugPrint(
      'PAYMENT SCAN BODY: ${response.body}',
    );

    dynamic decodedBody;

    try {
      decodedBody = jsonDecode(response.body);
    } catch (e) {
      throw Exception(
        'Invalid response received from payment server.',
      );
    }

    if (response.statusCode == 200 ||
        response.statusCode == 201) {
      if (decodedBody is! Map<String, dynamic>) {
        throw Exception(
          'Invalid payment response format.',
        );
      }

      /*
      |--------------------------------------------------------------------------
      | API Response
      |--------------------------------------------------------------------------
      |
      | {
      |   "status": "success",
      |   "message": "...",
      |   "data": {
      |      "student": {},
      |      "classes": []
      |   }
      | }
      |
      */

      final data = decodedBody['data'];

      if (data is! Map<String, dynamic>) {
        throw Exception(
          'Payment data not found in server response.',
        );
      }

      return ScanPaymentResponseModel.fromJson(
        data,
      );
    }

    final message =
        decodedBody is Map<String, dynamic>
            ? decodedBody['message']?.toString()
            : null;

    throw Exception(
      message ?? 'Failed to scan payment.',
    );
  }
}