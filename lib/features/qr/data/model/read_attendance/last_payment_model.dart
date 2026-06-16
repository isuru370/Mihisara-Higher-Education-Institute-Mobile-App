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

  factory LastPaymentModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return LastPaymentModel(
      paymentId:
          json?['payment_id'] as int? ?? 0,

      amount:
          json?['amount'] as String? ?? '',

      discountAmount:
          json?['discount_amount'] as String? ??
              '',

      paymentMonth:
          json?['payment_month'] as String? ??
              '',

      paymentMethod:
          json?['payment_method'] as String? ??
              '',

      receiptNumber:
          json?['receipt_number'] as String? ??
              '',

      paidAt:
          json?['paid_at'] as String? ?? '',

      status:
          json?['status'] as String? ?? '',
    );
  }
}