class EnrollmentModel {
  final int id;
  final int studentClassId;
  final int classCategoryFeeId;
  final int finalFee;
  final bool isFreeCard;

  EnrollmentModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.finalFee,
    required this.isFreeCard,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'],
      studentClassId: json['student_class_id'],
      classCategoryFeeId: json['class_category_fee_id'],
      finalFee: json['final_fee'],
      isFreeCard: json['is_free_card'],
    );
  }
}