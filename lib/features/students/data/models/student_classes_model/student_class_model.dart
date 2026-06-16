class StudentClassModel {
  final int enrollmentId;
  final int classId;
  final String className;
  final String gradeName;
  final String teacherName;
  final int classCategoryFeeId;
  final String categoryName;
  final bool isActive;
  final bool isFreeCard;
  final double defultFee;
  final double finalFee;
  final double paidAmount;
  final double balance;
  final String paymentStatus;
  final DateTime? registeredDate;

  StudentClassModel({
    required this.enrollmentId,
    required this.classId,
    required this.className,
    required this.gradeName,
    required this.teacherName,
    required this.classCategoryFeeId,
    required this.categoryName,
    required this.isActive,
    required this.isFreeCard,
    required this.finalFee,
    required this.defultFee,
    required this.paidAmount,
    required this.balance,
    required this.paymentStatus,
    required this.registeredDate,
  });

  factory StudentClassModel.fromJson(Map<String, dynamic> json) {
    return StudentClassModel(
      enrollmentId: int.tryParse(json['enrollment_id'].toString()) ?? 0,

      classId: int.tryParse(json['class_id'].toString()) ?? 0,

      className: json['class_name']?.toString() ?? '',

      gradeName: json['grade_name']?.toString() ?? '',

      teacherName: json['teacher_name']?.toString() ?? '',

      classCategoryFeeId:
          int.tryParse(json['class_category_fee_id'].toString()) ?? 0,

      categoryName: json['category_name']?.toString() ?? '',

      isActive: json['is_active'] ?? false,

      isFreeCard: json['is_free_card'] ?? false,

      defultFee: double.tryParse(json['defult_fee'].toString()) ?? 0.0,

      finalFee: double.tryParse(json['final_fee'].toString()) ?? 0.0,

      paidAmount: double.tryParse(json['paid_amount'].toString()) ?? 0.0,

      balance: double.tryParse(json['balance'].toString()) ?? 0.0,

      paymentStatus: json['payment_status']?.toString() ?? '',

      registeredDate: json['registered_date'] != null
          ? DateTime.tryParse(json['registered_date'])
          : null,
    );
  }
}
