class TodayPaymentCategoryModel {
  final int id;
  final String name;

  const TodayPaymentCategoryModel({
    required this.id,
    required this.name,
  });

  factory TodayPaymentCategoryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentCategoryModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      name:
          json['name']?.toString() ?? '',
    );
  }

  factory TodayPaymentCategoryModel.empty() {
    return const TodayPaymentCategoryModel(
      id: 0,
      name: '',
    );
  }
}