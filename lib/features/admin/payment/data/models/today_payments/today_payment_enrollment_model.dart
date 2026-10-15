class TodayPaymentEnrollmentModel {
  final int id;
  final bool isFreeCard;
  final double finalFee;
  final double balance;
  final String? paymentStatus;

  const TodayPaymentEnrollmentModel({
    required this.id,
    required this.isFreeCard,
    required this.finalFee,
    required this.balance,
    required this.paymentStatus,
  });

  factory TodayPaymentEnrollmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentEnrollmentModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      isFreeCard:
          json['is_free_card'] == true,

      finalFee: double.tryParse(
            json['final_fee']?.toString() ?? '0',
          ) ??
          0.0,

      balance: double.tryParse(
            json['balance']?.toString() ?? '0',
          ) ??
          0.0,

      paymentStatus:
          json['payment_status']?.toString(),
    );
  }

  factory TodayPaymentEnrollmentModel.empty() {
    return const TodayPaymentEnrollmentModel(
      id: 0,
      isFreeCard: false,
      finalFee: 0.0,
      balance: 0.0,
      paymentStatus: null,
    );
  }
}