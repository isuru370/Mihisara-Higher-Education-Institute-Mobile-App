class ScanPaymentLastPaymentModel {
  final int? id;
  final String? receiptNumber;
  final double amount;
  final String? paymentMonth;
  final String? paymentMonthName;
  final String? paidAt;
  final String? paymentMethod;

  const ScanPaymentLastPaymentModel({
    this.id,
    this.receiptNumber,
    this.amount = 0,
    this.paymentMonth,
    this.paymentMonthName,
    this.paidAt,
    this.paymentMethod,
  });

  factory ScanPaymentLastPaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanPaymentLastPaymentModel(
      id: json['id'] is int
          ? json['id']
          : int.tryParse(
              json['id']?.toString() ?? '',
            ),

      receiptNumber:
          json['receipt_number']?.toString(),

      amount: _toDouble(json['amount']),

      paymentMonth:
          json['payment_month']?.toString(),

      paymentMonthName:
          json['payment_month_name']?.toString(),

      paidAt: json['paid_at']?.toString(),

      paymentMethod:
          json['payment_method']?.toString(),
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }
}