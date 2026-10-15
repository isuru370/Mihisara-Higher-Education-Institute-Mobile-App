class MarkPaymentModel {
  final int id;
  final String receiptNumber;
  final String paymentMonth;
  final String paymentMethod;
  final String status;

  final double amount;
  final double discountAmount;

  final String paidAt;

  final double classFee;
  final double hallFee;
  final double totalFee;
  final double finalFee;
  final double balance;

  final String paymentStatus;

  const MarkPaymentModel({
    required this.id,
    required this.receiptNumber,
    required this.paymentMonth,
    required this.paymentMethod,
    required this.status,
    required this.amount,
    required this.discountAmount,
    required this.paidAt,
    required this.classFee,
    required this.hallFee,
    required this.totalFee,
    required this.finalFee,
    required this.balance,
    required this.paymentStatus,
  });

  factory MarkPaymentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final feeJson = json['fee'];

    final Map<String, dynamic> fee =
        feeJson is Map<String, dynamic>
            ? feeJson
            : <String, dynamic>{};

    return MarkPaymentModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      receiptNumber:
          json['receipt_number']?.toString() ?? '',

      paymentMonth:
          json['payment_month']?.toString() ?? '',

      paymentMethod:
          json['payment_method']?.toString() ?? '',

      status:
          json['status']?.toString() ?? '',

      amount: _toDouble(
        json['amount'],
      ),

      discountAmount: _toDouble(
        json['discount_amount'],
      ),

      paidAt:
          json['paid_at']?.toString() ?? '',

      classFee: _toDouble(
        fee['class_fee'],
      ),

      hallFee: _toDouble(
        fee['hall_fee'],
      ),

      totalFee: _toDouble(
        fee['total_fee'],
      ),

      finalFee: _toDouble(
        fee['final_fee'],
      ),

      balance: _toDouble(
        fee['balance'],
      ),

      paymentStatus:
          fee['payment_status']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    return double.tryParse(
          value?.toString() ?? '0',
        ) ??
        0.0;
  }
}