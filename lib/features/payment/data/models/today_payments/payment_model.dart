class PaymentModel {
  final int id;
  final String markMethod;
  final String amount;
  final String discountAmount;
  final DateTime? paidAt;
  final DateTime? paymentMonth;
  final String receiptNumber;

  PaymentModel({
    required this.id,
    required this.markMethod,
    required this.amount,
    required this.discountAmount,
    required this.paidAt,
    required this.paymentMonth,
    required this.receiptNumber,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] ?? 0,
      markMethod: json['mark_method'] ?? '',
      amount: json['amount']?.toString() ?? '0',
      discountAmount: json['discount_amount']?.toString() ?? '0',
      paidAt: json['paid_at'] != null ? DateTime.tryParse(json['paid_at']) : null,
      paymentMonth: json['payment_month'] != null
          ? DateTime.tryParse(json['payment_month'])
          : null,
      receiptNumber: json['receipt_number'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mark_method': markMethod,
      'amount': amount,
      'discount_amount': discountAmount,
      'paid_at': paidAt?.toIso8601String(),
      'payment_month': paymentMonth?.toIso8601String(),
      'receipt_number': receiptNumber,
    };
  }
}