import '../../../../qr/data/model/scan_attendance_new/fee_option_model.dart';

class StudentClassModel {
  final int enrollmentId;
  final int classId;
  final String className;
  final String gradeName;
  final String teacherName;

  final int classCategoryFeeId;
  final String categoryName;

  final int classCategoryFeeOptionId;
  final FeeOptionModel? feeOption;

  final bool isActive;
  final bool isFreeCard;

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
    required this.classCategoryFeeOptionId,
    required this.feeOption,
    required this.isActive,
    required this.isFreeCard,
    required this.finalFee,
    required this.paidAmount,
    required this.balance,
    required this.paymentStatus,
    required this.registeredDate,
  });

  factory StudentClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return StudentClassModel(
      enrollmentId: int.tryParse(
            json['enrollment_id']?.toString() ?? '0',
          ) ??
          0,

      classId: int.tryParse(
            json['class_id']?.toString() ?? '0',
          ) ??
          0,

      className:
          json['class_name']?.toString() ?? '',

      gradeName:
          json['grade_name']?.toString() ?? '',

      teacherName:
          json['teacher_name']?.toString() ?? '',

      classCategoryFeeId: int.tryParse(
            json['class_category_fee_id']?.toString() ?? '0',
          ) ??
          0,

      categoryName:
          json['category_name']?.toString() ?? '',

      classCategoryFeeOptionId: int.tryParse(
            json['class_category_fee_option_id']?.toString() ?? '0',
          ) ??
          0,

      // The API sends the option flat (fee_option_label / fee_option_fee)
      // rather than a fee_option object, so the label never showed.
      feeOption: json['fee_option'] is Map<String, dynamic>
          ? FeeOptionModel.fromJson(
              json['fee_option'] as Map<String, dynamic>,
            )
          : (json['fee_option_label'] != null
              ? FeeOptionModel(
                  id: int.tryParse(
                        json['class_category_fee_option_id']?.toString() ?? '',
                      ) ??
                      0,
                  classCategoryFeeId: int.tryParse(
                        json['class_category_fee_id']?.toString() ?? '',
                      ) ??
                      0,
                  label: json['fee_option_label'].toString(),
                  fee: double.tryParse(
                        json['fee_option_fee']?.toString() ?? '',
                      ) ??
                      0,
                  isDefault: false,
                  isActive: true,
                )
              : null),

      isActive:
          json['is_active'] == true,

      isFreeCard:
          json['is_free_card'] == true,

      finalFee: double.tryParse(
            json['final_fee']?.toString() ?? '0',
          ) ??
          0.0,

      paidAmount: double.tryParse(
            json['paid_amount']?.toString() ?? '0',
          ) ??
          0.0,

      balance: double.tryParse(
            json['balance']?.toString() ?? '0',
          ) ??
          0.0,

      paymentStatus:
          json['payment_status']?.toString() ?? '',

      registeredDate: json['registered_date'] != null
          ? DateTime.tryParse(
              json['registered_date'].toString(),
            )
          : null,
    );
  }
}


