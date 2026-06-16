class PaymentSummaryModel {
  final double totalPaid;
  final int totalPayments;
  final int activePayments;

  PaymentSummaryModel({
    required this.totalPaid,
    required this.totalPayments,
    required this.activePayments,
  });

  factory PaymentSummaryModel.fromJson(Map<String, dynamic> json) {
    return PaymentSummaryModel(
      totalPaid: (json['total_paid'] as num?)?.toDouble() ?? 0.0,
      totalPayments: json['total_payments'] ?? 0,
      activePayments: json['active_payments'] ?? 0,
    );
  }
}
