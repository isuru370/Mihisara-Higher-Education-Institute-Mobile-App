class PaymentInfo {
  final bool isPaid;
  final String? paymentMonth;
  final String? paidAt;
  final double? amount;
  final String? receiptNumber;

  PaymentInfo({
    required this.isPaid,
    this.paymentMonth,
    this.paidAt,
    this.amount,
    this.receiptNumber,
  });

  factory PaymentInfo.fromJson(Map<String, dynamic> json) {
    return PaymentInfo(
      isPaid: json['is_paid'] ?? false,
      paymentMonth: json['payment_month'],
      paidAt: json['paid_at'],
      amount: json['amount'] == null
          ? null
          : double.tryParse(json['amount'].toString()),
      receiptNumber: json['receipt_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_paid': isPaid,
      'payment_month': paymentMonth,
      'paid_at': paidAt,
      'amount': amount,
      'receipt_number': receiptNumber,
    };
  }
}
