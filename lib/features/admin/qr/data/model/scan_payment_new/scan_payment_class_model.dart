import 'scan_payment_fee_option_model.dart';
import 'scan_payment_last_payment_model.dart';

class ScanPaymentClassModel {
  final int? enrollmentId;
  final bool isFreeCard;

  final String className;
  final String subject;
  final String grade;
  final String teacherInitials;

  final String categoryName;
  final int? categoryId;
  final int? feeId;

  final ScanPaymentFeeOptionModel? feeOption;

  final double classFee;
  final double hallFee;
  final double totalFee;
  final double finalFee;

  final double balance;
  final String? paymentStatus;

  final ScanPaymentAttendanceModel? attendance;

  final ScanPaymentLastPaymentModel? lastPayment;

  const ScanPaymentClassModel({
    this.enrollmentId,
    this.isFreeCard = false,
    this.className = '',
    this.subject = '',
    this.grade = '',
    this.teacherInitials = '',
    this.categoryName = '',
    this.categoryId,
    this.feeId,
    this.feeOption,
    this.classFee = 0,
    this.hallFee = 0,
    this.totalFee = 0,
    this.finalFee = 0,
    this.balance = 0,
    this.paymentStatus,
    this.attendance,
    this.lastPayment,
  });

  factory ScanPaymentClassModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanPaymentClassModel(
      enrollmentId: json['enrollment_id'] is int
          ? json['enrollment_id']
          : int.tryParse(
              json['enrollment_id']?.toString() ?? '',
            ),

      isFreeCard: json['is_free_card'] == true ||
          json['is_free_card'] == 1,

      className: json['class_name']?.toString() ?? '',

      subject: json['subject']?.toString() ?? '',

      grade: json['grade']?.toString() ?? '',

      teacherInitials:
          json['teacher_initials']?.toString() ?? '',

      categoryName:
          json['category_name']?.toString() ?? '',

      categoryId: json['category_id'] is int
          ? json['category_id']
          : int.tryParse(
              json['category_id']?.toString() ?? '',
            ),

      feeId: json['fee_id'] is int
          ? json['fee_id']
          : int.tryParse(
              json['fee_id']?.toString() ?? '',
            ),

      feeOption: json['fee_option'] is Map
          ? ScanPaymentFeeOptionModel.fromJson(
              Map<String, dynamic>.from(
                json['fee_option'],
              ),
            )
          : null,

      classFee: _toDouble(json['class_fee']),

      hallFee: _toDouble(json['hall_fee']),

      totalFee: _toDouble(json['total_fee']),

      finalFee: _toDouble(json['final_fee']),

      balance: _toDouble(json['balance']),

      paymentStatus:
          json['payment_status']?.toString(),

      attendance: json['attendance'] is Map
          ? ScanPaymentAttendanceModel.fromJson(
              Map<String, dynamic>.from(
                json['attendance'],
              ),
            )
          : null,

      lastPayment: json['last_payment'] is Map
          ? ScanPaymentLastPaymentModel.fromJson(
              Map<String, dynamic>.from(
                json['last_payment'],
              ),
            )
          : null,
    );
  }

  static double _toDouble(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is num) {
      return value.toDouble();
    }

    return double.tryParse(
          value.toString(),
        ) ??
        0;
  }
}

class ScanPaymentAttendanceModel {
  final int classDays;
  final int attendedDays;

  const ScanPaymentAttendanceModel({
    this.classDays = 0,
    this.attendedDays = 0,
  });

  factory ScanPaymentAttendanceModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanPaymentAttendanceModel(
      classDays: _toInt(json['class_days']),
      attendedDays: _toInt(json['attended_days']),
    );
  }

  static int _toInt(dynamic value) {
    if (value == null) {
      return 0;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
          value.toString(),
        ) ??
        0;
  }
}