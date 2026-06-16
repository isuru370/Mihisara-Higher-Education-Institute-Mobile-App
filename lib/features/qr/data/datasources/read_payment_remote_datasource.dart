import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import '../../../../core/constants/api_constants.dart';
import '../../../../core/storage/session_storage.dart';
import '../model/read_payment/read_payments_response_model.dart';

class ReadPaymentRemoteDataSource {
  Future<ReadPaymentResponseModel> readPayment({required String qrCode}) async {
    final token = await SessionStorage.getToken();

    final response = await http.post(
      Uri.parse('${ApiConstants.apiUrl}/payments/read'),
      headers: {
        ...ApiConstants.headers(token: token),
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'qr_code': qrCode}),
    );

    debugPrint(response.body);

    final Map<String, dynamic> body =
        jsonDecode(response.body) as Map<String, dynamic>;

    if (response.statusCode == 200) {
      return ReadPaymentResponseModel.fromJson(body);
    } else {
      throw Exception(body['message'] ?? 'Request failed');
    }
  }
}
