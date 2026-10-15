import 'payment_item_model.dart';

class MonthlyPaymentModel {
  final String month;
  final String monthName;
  final int count;
  final double totalAmount;
  final double totalDiscountAmount;
  final List<PaymentItemModel> payments;

  MonthlyPaymentModel({
    required this.month,
    required this.monthName,
    required this.count,
    required this.totalAmount,
    required this.totalDiscountAmount,
    required this.payments,
  });

  factory MonthlyPaymentModel.fromJson(Map<String, dynamic> json) {
    return MonthlyPaymentModel(
      month: json['month'] ?? '',
      monthName: json['month_name'] ?? '',
      count: json['count'] ?? 0,
      totalAmount: (json['total_amount'] as num?)?.toDouble() ?? 0.0,
      totalDiscountAmount:
          (json['total_discount_amount'] as num?)?.toDouble() ?? 0.0,
      payments: (json['payments'] as List<dynamic>? ?? [])
          .map((e) => PaymentItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}