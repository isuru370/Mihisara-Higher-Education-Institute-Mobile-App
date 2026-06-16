class CreateTuteRequestModel {
  final int studentId;
  final int studentClassEnrollmentId;
  final String issuedMonth;
  final bool isIssued;
  final String? issuedAt;
  final String? note;

  CreateTuteRequestModel({
    required this.studentId,
    required this.studentClassEnrollmentId,
    required this.issuedMonth,
    this.isIssued = false,
    this.issuedAt,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_class_enrollment_id': studentClassEnrollmentId,
      'issued_month': issuedMonth,
      'is_issued': isIssued,
      'issued_at': issuedAt,
      'note': note,
    };
  }
}