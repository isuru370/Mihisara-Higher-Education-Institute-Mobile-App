class CreateStudentTuteResponseModel {
  final bool success;
  final String message;
  final StudentTuteData? data;

  CreateStudentTuteResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory CreateStudentTuteResponseModel.fromJson(
      Map<String, dynamic> json) {
    return CreateStudentTuteResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? StudentTuteData.fromJson(json['data'])
          : null,
    );
  }
}

class StudentTuteData {
  final int id;
  final int studentId;
  final int studentClassEnrollmentId;
  final bool isIssued;
  final String? issuedAt;
  final int? issuedBy;
  final String? note;

  StudentTuteData({
    required this.id,
    required this.studentId,
    required this.studentClassEnrollmentId,
    required this.isIssued,
    this.issuedAt,
    this.issuedBy,
    this.note,
  });

  factory StudentTuteData.fromJson(
      Map<String, dynamic> json) {
    return StudentTuteData(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentClassEnrollmentId:
          json['student_class_enrollment_id'] ?? 0,
      isIssued: json['is_issued'] ?? false,
      issuedAt: json['issued_at'],
      issuedBy: json['issued_by'],
      note: json['note'],
    );
  }
}