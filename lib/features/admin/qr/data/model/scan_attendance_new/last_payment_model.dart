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
    Map<String, dynamic> json,
  ) {
    return LastPaymentModel(
      paymentId: _toInt(json['payment_id']),

      amount:
          json['amount']?.toString() ?? '0.00',

      discountAmount:
          json['discount_amount']?.toString() ?? '0.00',

      paymentMonth:
          json['payment_month']?.toString() ?? '',

      paymentMethod:
          json['payment_method']?.toString() ?? '',

      receiptNumber:
          json['receipt_number']?.toString() ?? '',

      paidAt:
          json['paid_at']?.toString() ?? '',

      status:
          json['status']?.toString() ?? '',
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(
          value?.toString() ?? '',
        ) ??
        0;
  }
}