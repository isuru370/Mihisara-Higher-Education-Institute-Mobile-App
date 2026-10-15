import 'monthly_payment_model.dart';

class PaymentHistoryResponseModel {
  final bool success;
  final int count;
  final List<MonthlyPaymentModel> data;

  PaymentHistoryResponseModel({
    required this.success,
    required this.count,
    required this.data,
  });

  factory PaymentHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryResponseModel(
      success: json['success'] ?? false,
      count: json['count'] ?? 0,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((e) => MonthlyPaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}