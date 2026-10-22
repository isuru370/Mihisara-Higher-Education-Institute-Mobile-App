class MarkPaymentStudentModel {
  final int studentId;
  final String name;
  final String customId;

  const MarkPaymentStudentModel({
    required this.studentId,
    required this.name,
    required this.customId,
  });

  factory MarkPaymentStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarkPaymentStudentModel(
      studentId: int.tryParse(
            json['student_id']?.toString() ?? '0',
          ) ??
          0,

      name:
          (json['name'] ?? json['initial_name'] ?? json['full_name'])?.toString() ?? '',

      customId:
          json['custom_id']?.toString() ?? '',
    );
  }

  factory MarkPaymentStudentModel.empty() {
    return const MarkPaymentStudentModel(
      studentId: 0,
      name: '',
      customId: '',
    );
  }
}