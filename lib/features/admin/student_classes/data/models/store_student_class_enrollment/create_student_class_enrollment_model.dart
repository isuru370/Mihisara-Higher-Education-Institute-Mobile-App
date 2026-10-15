class CreateStudentClassEnrollmentModel {
  final int? id;

  final int studentId;
  final int studentClassId;
  final int classCategoryFeeId;
  final int classCategoryFeeOptionId;

  final bool isFreeCard;

  final String? enrolledAt;
  final String? note;

  final bool? isActive;
  final String? leftAt;

  final String? createdAt;
  final String? updatedAt;

  CreateStudentClassEnrollmentModel({
    this.id,
    required this.studentId,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.classCategoryFeeOptionId,
    this.isFreeCard = false,
    this.enrolledAt,
    this.note,
    this.isActive,
    this.leftAt,
    this.createdAt,
    this.updatedAt,
  });

  factory CreateStudentClassEnrollmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return CreateStudentClassEnrollmentModel(
      id: _parseInt(json['id']),
      studentId: _parseInt(json['student_id']),
      studentClassId: _parseInt(json['student_class_id']),
      classCategoryFeeId: _parseInt(
        json['class_category_fee_id'],
      ),
      classCategoryFeeOptionId: _parseInt(
        json['class_category_fee_option_id'],
      ),

      isFreeCard: _parseBool(
        json['is_free_card'],
      ),

      enrolledAt: json['enrolled_at']?.toString(),

      note: json['note']?.toString(),

      isActive: json['is_active'] != null
          ? _parseBool(json['is_active'])
          : null,

      leftAt: json['left_at']?.toString(),

      createdAt: json['created_at']?.toString(),

      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
      'class_category_fee_option_id': classCategoryFeeOptionId,
      'is_free_card': isFreeCard,
      'enrolled_at': enrolledAt,
      'note': note,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;

    if (value is String) {
      return int.tryParse(value) ?? 0;
    }

    if (value is double) {
      return value.toInt();
    }

    return 0;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;

    if (value is int) {
      return value == 1;
    }

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' ||
          normalized == '1';
    }

    return false;
  }
}