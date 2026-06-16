class PaymentItemModel {
  final int id;
  final String markMethod;
  final double amount;
  final double discountAmount;
  final String note;
  final String paidAt;
  final String paymentMonth;
  final String receiptNumber;
  final String status;

  PaymentItemModel({
    required this.id,
    required this.markMethod,
    required this.amount,
    required this.discountAmount,
    required this.note,
    required this.paidAt,
    required this.paymentMonth,
    required this.receiptNumber,
    required this.status,
  });

  factory PaymentItemModel.fromJson(Map<String, dynamic> json) {
    return PaymentItemModel(
      id: json['id'] ?? 0,
      markMethod: json['mark_method'] ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0.0,
      discountAmount: (json['discount_amount'] as num?)?.toDouble() ?? 0.0,
      note: json['note'] ?? '',
      paidAt: json['paid_at'] ?? '',
      paymentMonth: json['payment_month'] ?? '',
      receiptNumber: json['receipt_number'] ?? '',
      status: json['status'] ?? '',
    );
  }
}