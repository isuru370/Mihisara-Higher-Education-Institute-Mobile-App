class TodayPaymentClassModel {
  final int id;
  final String className;

  const TodayPaymentClassModel({
    required this.id,
    required this.className,
  });

  factory TodayPaymentClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentClassModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      className:
          json['class_name']?.toString() ?? '',
    );
  }

  factory TodayPaymentClassModel.empty() {
    return const TodayPaymentClassModel(
      id: 0,
      className: '',
    );
  }
}