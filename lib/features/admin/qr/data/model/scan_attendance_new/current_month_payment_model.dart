/// Whether the student has paid this month's fee for the scanned class.
/// Sent by the server as `current_month_payment`.
class CurrentMonthPaymentModel {
  /// "2026-10"
  final String month;

  /// "October 2026"
  final String monthLabel;
  final bool isPaid;
  final bool isFreeCard;
  final String receiptNumber;
  final String paidAt;

  CurrentMonthPaymentModel({
    required this.month,
    required this.monthLabel,
    required this.isPaid,
    required this.isFreeCard,
    required this.receiptNumber,
    required this.paidAt,
  });

  factory CurrentMonthPaymentModel.fromJson(Map<String, dynamic> json) {
    return CurrentMonthPaymentModel(
      month: json['month']?.toString() ?? '',
      monthLabel: json['month_label']?.toString() ?? '',
      isPaid: json['is_paid'] == true,
      isFreeCard: json['is_free_card'] == true,
      receiptNumber: json['receipt_number']?.toString() ?? '',
      paidAt: json['paid_at']?.toString() ?? '',
    );
  }
}
