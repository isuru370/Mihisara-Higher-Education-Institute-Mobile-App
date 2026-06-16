class CreateStudentClassEnrollmentModel {
  final int? id;
  final int studentId;
  final int studentClassId;
  final int classCategoryFeeId;

  final bool isFreeCard;

  final double? customFee;
  final String? customFeeReason;

  final double? discountPercentage;
  final String? discountReason;

  final String? enrolledAt;
  final String? note;

  final bool? isActive;
  final String? createdAt;
  final String? updatedAt;

  CreateStudentClassEnrollmentModel({
    this.id,
    required this.studentId,
    required this.studentClassId,
    required this.classCategoryFeeId,
    this.isFreeCard = false,
    this.customFee,
    this.customFeeReason,
    this.discountPercentage,
    this.discountReason,
    this.enrolledAt,
    this.note,
    this.isActive,
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
      classCategoryFeeId: _parseInt(json['class_category_fee_id']),

      isFreeCard: _parseBool(json['is_free_card']),

      customFee: _parseDouble(json['custom_fee']),
      customFeeReason: json['custom_fee_reason']?.toString(),

      discountPercentage: _parseDouble(json['discount_percentage']),
      discountReason: json['discount_reason']?.toString(),

      enrolledAt: json['enrolled_at']?.toString(),
      note: json['note']?.toString(),

      isActive: json['is_active'] != null
          ? _parseBool(json['is_active'])
          : null,

      createdAt: json['created_at']?.toString(),
      updatedAt: json['updated_at']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_class_id': studentClassId,
      'class_category_fee_id': classCategoryFeeId,
      'is_free_card': isFreeCard,
      'custom_fee': customFee,
      'custom_fee_reason': customFeeReason,
      'discount_percentage': discountPercentage,
      'discount_reason': discountReason,
      'enrolled_at': enrolledAt,
      'note': note,
    };
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    if (value is double) return value.toInt();
    return 0;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  static bool _parseBool(dynamic value) {
    if (value is bool) return value;
    if (value is int) return value == 1;

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      return normalized == 'true' || normalized == '1';
    }

    return false;
  }
}