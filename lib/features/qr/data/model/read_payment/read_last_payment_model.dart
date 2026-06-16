class ReadLastPaymentModel {
  final int paymentId;
  final String amount;
  final String discountAmount;
  final String paymentMonth;
  final String paymentMethod;
  final String receiptNumber;
  final String paidAt;
  final String status;

  ReadLastPaymentModel({
    required this.paymentId,
    required this.amount,
    required this.discountAmount,
    required this.paymentMonth,
    required this.paymentMethod,
    required this.receiptNumber,
    required this.paidAt,
    required this.status,
  });

  factory ReadLastPaymentModel.fromJson(Map<String, dynamic> json) {
    return ReadLastPaymentModel(
      paymentId: json['payment_id'] ?? 0,
      amount: json['amount']?.toString() ?? '0',
      discountAmount: json['discount_amount']?.toString() ?? '0',
      paymentMonth: json['payment_month'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      receiptNumber: json['receipt_number'] ?? '',
      paidAt: json['paid_at'] ?? '',
      status: json['status'] ?? '',
    );
  }
}
