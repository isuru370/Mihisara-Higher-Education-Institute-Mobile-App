class ReadTuteEnrollmentModel {
  final int enrollmentId;
  final int studentClassId;
  final String? className;
  final String? gradeName;
  final String? categoryName;
  final String? teacherName;
  final String? paymentStatus;
  final num finalFee;
  final bool tuteIssued;
  final String? tuteStatus;
  final String? tuteIssuedAt;

  ReadTuteEnrollmentModel({
    required this.enrollmentId,
    required this.studentClassId,
    this.className,
    this.gradeName,
    this.categoryName,
    this.teacherName,
    this.paymentStatus,
    required this.finalFee,
    required this.tuteIssued,
    this.tuteStatus,
    this.tuteIssuedAt,
  });

  factory ReadTuteEnrollmentModel.fromJson(Map<String, dynamic> json) {
    return ReadTuteEnrollmentModel(
      enrollmentId: json['enrollment_id'] ?? 0,
      studentClassId: json['student_class_id'] ?? 0,
      className: json['class_name'],
      gradeName: json['grade_name'],
      categoryName: json['category_name'],
      teacherName: json['teacher_name'],
      paymentStatus: json['payment_status'],
      finalFee: json['final_fee'] ?? 0,
      tuteIssued: json['tute_issued'] ?? false,
      tuteStatus: json['tute_status'],
      tuteIssuedAt: json['tute_issued_at'],
    );
  }
}
