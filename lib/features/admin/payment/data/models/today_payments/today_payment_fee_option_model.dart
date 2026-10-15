class TodayPaymentFeeOptionModel {
  final int id;
  final String name;
  final double fee;

  const TodayPaymentFeeOptionModel({
    required this.id,
    required this.name,
    required this.fee,
  });

  factory TodayPaymentFeeOptionModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentFeeOptionModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      name:
          json['name']?.toString() ?? '',

      fee: double.tryParse(
            json['fee']?.toString() ?? '0',
          ) ??
          0.0,
    );
  }

  factory TodayPaymentFeeOptionModel.empty() {
    return const TodayPaymentFeeOptionModel(
      id: 0,
      name: '',
      fee: 0.0,
    );
  }
}