class AdmissionPaymentRequestModel {
  final int studentId;
  final int admissionId;

  const AdmissionPaymentRequestModel({
    required this.studentId,
    required this.admissionId,
  });

  Map<String, dynamic> toJson() {
    return {'student_id': studentId, 'admission_id': admissionId};
  }

  factory AdmissionPaymentRequestModel.fromJson(Map<String, dynamic> json) {
    return AdmissionPaymentRequestModel(
      studentId: json['student_id'] ?? 0,
      admissionId: json['admission_id'] ?? 0,
    );
  }

  AdmissionPaymentRequestModel copyWith({int? studentId, int? admissionId}) {
    return AdmissionPaymentRequestModel(
      studentId: studentId ?? this.studentId,
      admissionId: admissionId ?? this.admissionId,
    );
  }
}
