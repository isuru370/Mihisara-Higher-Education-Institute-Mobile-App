class TodayPaymentGradeModel {
  final int id;
  final String name;

  const TodayPaymentGradeModel({
    required this.id,
    required this.name,
  });

  factory TodayPaymentGradeModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentGradeModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      name:
          json['name']?.toString() ?? '',
    );
  }

  factory TodayPaymentGradeModel.empty() {
    return const TodayPaymentGradeModel(
      id: 0,
      name: '',
    );
  }
}