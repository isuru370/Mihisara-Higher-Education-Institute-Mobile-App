class TodayPaymentSummaryModel {
  final int paymentCount;
  final double totalAmount;
  final double totalDiscount;

  const TodayPaymentSummaryModel({
    required this.paymentCount,
    required this.totalAmount,
    required this.totalDiscount,
  });

  factory TodayPaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return TodayPaymentSummaryModel(
      paymentCount: int.tryParse(json['payment_count']?.toString() ?? '0') ?? 0,

      totalAmount:
          double.tryParse(json['total_amount']?.toString() ?? '0') ?? 0.0,

      totalDiscount:
          double.tryParse(json['total_discount']?.toString() ?? '0') ?? 0.0,
    );
  }
}
