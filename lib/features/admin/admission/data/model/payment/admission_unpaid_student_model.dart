class AdmissionUnpaidStudentModel {
  final int id;
  final String customId;
  final String name;
  final String grade;
  final String guardianMobile;
  final String temporaryQrCode;
  final bool admission;

  const AdmissionUnpaidStudentModel({
    required this.id,
    required this.customId,
    required this.name,
    required this.grade,
    required this.guardianMobile,
    required this.temporaryQrCode,
    required this.admission,
  });

  factory AdmissionUnpaidStudentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AdmissionUnpaidStudentModel(
      id: json['id'] ?? 0,
      customId: json['custom_id'] ?? '',
      name: json['name'] ?? '',
      grade: json['grade'] ?? '',
      guardianMobile:
          json['guardian_mobile'] ?? '',
      temporaryQrCode:
          json['temporary_qr_code'] ?? '',
      admission: json['admission'] ?? false,
    );
  }
}