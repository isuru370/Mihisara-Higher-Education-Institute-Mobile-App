class StudentTuteModel {
  final int id;
  final int studentId;
  final int studentClassEnrollmentId;
  final bool isIssued;
  final String? issuedAt;
  final int? issuedBy;
  final String? note;
  final IssuedByUserModel? issuedByUser;
  final String? createdAt;
  final String? updatedAt;

  StudentTuteModel({
    required this.id,
    required this.studentId,
    required this.studentClassEnrollmentId,
    required this.isIssued,
    this.issuedAt,
    this.issuedBy,
    this.note,
    this.issuedByUser,
    this.createdAt,
    this.updatedAt,
  });

  factory StudentTuteModel.fromJson(
      Map<String, dynamic> json) {
    return StudentTuteModel(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? 0,
      studentClassEnrollmentId:
          json['student_class_enrollment_id'] ?? 0,
      isIssued: json['is_issued'] ?? false,
      issuedAt: json['issued_at'],
      issuedBy: json['issued_by'],
      note: json['note'],
      issuedByUser: json['issued_by_user'] != null
          ? IssuedByUserModel.fromJson(
              json['issued_by_user'])
          : json['issued_by'] != null &&
                  json['issued_by'] is Map<String, dynamic>
              ? IssuedByUserModel.fromJson(
                  json['issued_by'])
              : null,
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'student_class_enrollment_id':
          studentClassEnrollmentId,
      'is_issued': isIssued,
      'issued_at': issuedAt,
      'issued_by': issuedBy,
      'note': note,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class IssuedByUserModel {
  final int id;
  final String name;

  IssuedByUserModel({
    required this.id,
    required this.name,
  });

  factory IssuedByUserModel.fromJson(
      Map<String, dynamic> json) {
    return IssuedByUserModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}