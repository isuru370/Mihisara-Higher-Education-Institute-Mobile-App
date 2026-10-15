class TeacherClassEnrollmentModel {
  final int id;

  final int? studentId;
  final int? studentClassId;

  final int? classCategoryFeeId;
  final int? classCategoryFeeOptionId;

  final bool isActive;
  final bool isFreeCard;

  final String? enrolledAt;
  final String? leftAt;

  const TeacherClassEnrollmentModel({
    required this.id,
    this.studentId,
    this.studentClassId,
    this.classCategoryFeeId,
    this.classCategoryFeeOptionId,
    required this.isActive,
    required this.isFreeCard,
    this.enrolledAt,
    this.leftAt,
  });

  factory TeacherClassEnrollmentModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherClassEnrollmentModel(
      id: json['id'] ?? 0,

      studentId: json['student_id'],

      studentClassId: json['student_class_id'],

      classCategoryFeeId:
          json['class_category_fee_id'],

      classCategoryFeeOptionId:
          json['class_category_fee_option_id'],

      isActive: json['is_active'] == true,

      isFreeCard: json['is_free_card'] == true,

      enrolledAt: json['enrolled_at']?.toString(),

      leftAt: json['left_at']?.toString(),
    );
  }
}