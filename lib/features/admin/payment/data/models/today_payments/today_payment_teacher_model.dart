class TodayPaymentTeacherModel {
  final int id;
  final String customId;
  final String name;

  const TodayPaymentTeacherModel({
    required this.id,
    required this.customId,
    required this.name,
  });

  factory TodayPaymentTeacherModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentTeacherModel(
      id: int.tryParse(
            json['id']?.toString() ?? '0',
          ) ??
          0,

      customId:
          json['custom_id']?.toString() ?? '',

      name:
          json['name']?.toString() ?? '',
    );
  }

  factory TodayPaymentTeacherModel.empty() {
    return const TodayPaymentTeacherModel(
      id: 0,
      customId: '',
      name: '',
    );
  }
}