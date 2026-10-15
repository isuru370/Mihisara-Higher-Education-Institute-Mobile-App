class StudentTuteModel {
  final int id;
  final int studentId;
  final int studentClassEnrollmentId;
  final String? issuedMonth;
  final bool isIssued;
  final String? issuedAt;
  final IssuedByUserModel? issuedBy;
  final String? note;
  final String? createdAt;
  final String? updatedAt;
  final String? deletedAt;

  StudentTuteModel({
    required this.id,
    required this.studentId,
    required this.studentClassEnrollmentId,
    this.issuedMonth,
    required this.isIssued,
    this.issuedAt,
    this.issuedBy,
    this.note,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  factory StudentTuteModel.fromJson(Map<String, dynamic> json) {
    return StudentTuteModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentClassEnrollmentId: json['student_class_enrollment_id'] ?? 0,
      issuedMonth: json['issued_month'],
      isIssued: json['is_issued'] ?? false,
      issuedAt: json['issued_at'],
      issuedBy: json['issued_by'] != null
          ? IssuedByUserModel.fromJson(json['issued_by'])
          : null,
      note: json['note'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      deletedAt: json['deleted_at'],
    );
  }
}

class IssuedByUserModel {
  final int id;
  final String name;

  IssuedByUserModel({
    required this.id,
    required this.name,
  });

  factory IssuedByUserModel.fromJson(Map<String, dynamic> json) {
    return IssuedByUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}