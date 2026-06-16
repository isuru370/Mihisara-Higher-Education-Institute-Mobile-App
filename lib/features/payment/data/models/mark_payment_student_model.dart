class MarkPaymentStudentModel {
  final int id;
  final String name;
  final String customId;
  final String guardianMobile;

  const MarkPaymentStudentModel({
    required this.id,
    required this.name,
    required this.customId,
    required this.guardianMobile,
  });

  factory MarkPaymentStudentModel.fromJson(Map<String, dynamic>? json) {
    return MarkPaymentStudentModel(
      id: json?['id'] ?? 0,
      name: json?['name'] ?? '',
      customId: json?['custom_id'] ?? '',
      guardianMobile: json?['guardian_mobile'] ?? '',
    );
  }
}
