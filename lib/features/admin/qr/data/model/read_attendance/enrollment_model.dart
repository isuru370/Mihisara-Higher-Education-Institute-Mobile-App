class EnrollmentModel {
  final String status;

  final bool isEnrolled;

  final int? enrollmentId;

  final int studentClassId;
  final int classCategoryFeeId;

  final String className;
  final String grade;
  final String subject;
  final String teacher;
  final String categoryName;

  final String defaultFee;

  final bool isFreeCard;

  final String finalFee;

  EnrollmentModel({
    required this.status,
    required this.isEnrolled,
    required this.enrollmentId,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.className,
    required this.grade,
    required this.subject,
    required this.teacher,
    required this.categoryName,
    required this.defaultFee,
    required this.isFreeCard,
    required this.finalFee,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic>? json) {
    return EnrollmentModel(
      status: json?['status'] as String? ?? '',
      isEnrolled: json?['is_enrolled'] as bool? ?? false,
      enrollmentId: (json?['enrollment_id'] as num?)?.toInt(),
      studentClassId: (json?['student_class_id'] as num?)?.toInt() ?? 0,
      classCategoryFeeId:
          (json?['class_category_fee_id'] as num?)?.toInt() ?? 0,
      className: json?['class_name'] as String? ?? '',
      grade: json?['grade'] as String? ?? '',
      subject: json?['subject'] as String? ?? '',
      teacher: json?['teacher'] as String? ?? '',
      categoryName: json?['category_name'] as String? ?? '',
      defaultFee: json?['default_fee']?.toString() ?? '0',
      isFreeCard: json?['is_free_card'] as bool? ?? false,
      finalFee: json?['final_fee']?.toString() ?? '0',
    );
  }
}
