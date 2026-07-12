class LastPaymentModel {
  final int paymentId;
  final String amount;
  final String discountAmount;
  final String paymentMonth;
  final String paymentMethod;
  final String receiptNumber;
  final String paidAt;
  final String status;

  LastPaymentModel({
    required this.paymentId,
    required this.amount,
    required this.discountAmount,
    required this.paymentMonth,
    required this.paymentMethod,
    required this.receiptNumber,
    required this.paidAt,
    required this.status,
  });

  factory LastPaymentModel.fromJson(Map<String, dynamic> json) {
    return LastPaymentModel(
      paymentId: json['payment_id'],
      amount: json['amount'],
      discountAmount: json['discount_amount'],
      paymentMonth: json['payment_month'],
      paymentMethod: json['payment_method'],
      receiptNumber: json['receipt_number'],
      paidAt: json['paid_at'],
      status: json['status'],
    );
  }
}