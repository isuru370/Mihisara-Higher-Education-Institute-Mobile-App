import 'fee_option_model.dart';

class EnrollmentModel {
  final int id;
  final int studentClassId;
  final int classCategoryFeeId;
  final int classCategoryFeeOptionId;
  final double finalFee;
  final bool isFreeCard;
  final FeeOptionModel? feeOption;

  EnrollmentModel({
    required this.id,
    required this.studentClassId,
    required this.classCategoryFeeId,
    required this.classCategoryFeeOptionId,
    required this.finalFee,
    required this.isFreeCard,
    this.feeOption,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: _toInt(json['id']),

      studentClassId: _toInt(json['student_class_id']),

      classCategoryFeeId: _toInt(json['class_category_fee_id']),

      classCategoryFeeOptionId: _toInt(json['class_category_fee_option_id']),

      finalFee: _toDouble(json['final_fee']),

      isFreeCard: json['is_free_card'] == true,

      feeOption: json['class_category_fee_option'] is Map<String, dynamic>
          ? FeeOptionModel.fromJson(
              json['class_category_fee_option'] as Map<String, dynamic>,
            )
          : null,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) {
      return value;
    }

    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(value?.toString() ?? '') ?? 0.0;
  }
}
