import 'dart:convert';

import '../../../../../core/network/api_http.dart' as http;

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/storage/session_storage.dart';
import '../models/mark_payment_request_model.dart';
import '../models/mark_payment_response_model.dart';
import '../models/payment_history/payment_history_request_model.dart';
import '../models/payment_history/payment_history_response_model.dart';
import '../models/today_payments/today_payments_request_model.dart';
import '../models/today_payments/today_payments_response_model.dart';

class MarkPaymentRemoteDataSource {
  const MarkPaymentRemoteDataSource();

  Future<MarkPaymentResponseModel> markPayment({
    required MarkPaymentRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/new-payment/bulk-pay'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(requestModel.toJson()),
      );

      final dynamic decoded = jsonDecode(response.body);

      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid server response');
      }

      final Map<String, dynamic> jsonBody = decoded;

      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic data = jsonBody['data'];

        if (data is! Map<String, dynamic>) {
          throw Exception(
            jsonBody['message']?.toString() ??
                'Payment response data not found',
          );
        }

        return MarkPaymentResponseModel.fromJson(data);
      }

      final message =
          jsonBody['message']?.toString() ?? 'Failed to mark payment';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<TodayPaymentsResponseModel> getTodayPayments({
    required TodayPaymentsRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final response = await http.post(
        Uri.parse('${ApiConstants.apiUrl}/payments/today'),
        headers: ApiConstants.headers(token: token),
        body: jsonEncode(requestModel.toJson()),
      );

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return TodayPaymentsResponseModel.fromJson(jsonBody);
      }

      final message =
          jsonBody['message']?.toString() ?? 'Failed to fetch payments';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<PaymentHistoryResponseModel> getPaymentHistory({
    required PaymentHistoryRequestModel requestModel,
  }) async {
    try {
      final token = await SessionStorage.getToken();

      final uri = Uri.parse(
        '${ApiConstants.apiUrl}/payments/students/${requestModel.studentId}/enrollments/${requestModel.enrollmentId}',
      );

      final response = await http.get(
        uri,
        headers: ApiConstants.headers(token: token),
      );

      final Map<String, dynamic> jsonBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return PaymentHistoryResponseModel.fromJson(jsonBody);
      }

      final message =
          jsonBody['message']?.toString() ?? 'Failed to fetch payment history';

      throw Exception(message);
    } on FormatException {
      throw Exception('Invalid server response format');
    } on http.ClientException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
