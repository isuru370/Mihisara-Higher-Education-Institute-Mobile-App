import 'today_payment_student_model.dart';
import 'today_payment_class_model.dart';
import 'today_payment_category_model.dart';
import 'today_payment_grade_model.dart';
import 'today_payment_teacher_model.dart';
import 'today_payment_fee_option_model.dart';
import 'today_payment_enrollment_model.dart';

class TodayPaymentItemModel {
  final int paymentId;
  final String receiptNumber;
  final double amount;
  final double discountAmount;
  final String paidAt;
  final String paymentMonth;
  final String paymentMethod;
  final String status;
  final String? referenceNumber;
  final String? markMethod;
  final String? note;

  final TodayPaymentStudentModel student;
  final TodayPaymentClassModel studentClass;
  final TodayPaymentCategoryModel category;
  final TodayPaymentGradeModel grade;
  final TodayPaymentTeacherModel teacher;
  final TodayPaymentFeeOptionModel feeOption;
  final TodayPaymentEnrollmentModel enrollment;

  const TodayPaymentItemModel({
    required this.paymentId,
    required this.receiptNumber,
    required this.amount,
    required this.discountAmount,
    required this.paidAt,
    required this.paymentMonth,
    required this.paymentMethod,
    required this.status,
    required this.referenceNumber,
    required this.markMethod,
    required this.note,
    required this.student,
    required this.studentClass,
    required this.category,
    required this.grade,
    required this.teacher,
    required this.feeOption,
    required this.enrollment,
  });

  factory TodayPaymentItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TodayPaymentItemModel(
      paymentId: int.tryParse(
            json['payment_id']?.toString() ?? '0',
          ) ??
          0,

      receiptNumber:
          json['receipt_number']?.toString() ?? '',

      amount: double.tryParse(
            json['amount']?.toString() ?? '0',
          ) ??
          0.0,

      discountAmount: double.tryParse(
            json['discount_amount']?.toString() ?? '0',
          ) ??
          0.0,

      paidAt:
          json['paid_at']?.toString() ?? '',

      paymentMonth:
          json['payment_month']?.toString() ?? '',

      paymentMethod:
          json['payment_method']?.toString() ?? '',

      status:
          json['status']?.toString() ?? '',

      referenceNumber:
          json['reference_number']?.toString(),

      markMethod:
          json['mark_method']?.toString(),

      note:
          json['note']?.toString(),

      student: json['student'] is Map<String, dynamic>
          ? TodayPaymentStudentModel.fromJson(
              json['student'],
            )
          : TodayPaymentStudentModel.empty(),

      studentClass: json['class'] is Map<String, dynamic>
          ? TodayPaymentClassModel.fromJson(
              json['class'],
            )
          : TodayPaymentClassModel.empty(),

      category: json['category'] is Map<String, dynamic>
          ? TodayPaymentCategoryModel.fromJson(
              json['category'],
            )
          : TodayPaymentCategoryModel.empty(),

      grade: json['grade'] is Map<String, dynamic>
          ? TodayPaymentGradeModel.fromJson(
              json['grade'],
            )
          : TodayPaymentGradeModel.empty(),

      teacher: json['teacher'] is Map<String, dynamic>
          ? TodayPaymentTeacherModel.fromJson(
              json['teacher'],
            )
          : TodayPaymentTeacherModel.empty(),

      feeOption: json['fee_option'] is Map<String, dynamic>
          ? TodayPaymentFeeOptionModel.fromJson(
              json['fee_option'],
            )
          : TodayPaymentFeeOptionModel.empty(),

      enrollment: json['enrollment'] is Map<String, dynamic>
          ? TodayPaymentEnrollmentModel.fromJson(
              json['enrollment'],
            )
          : TodayPaymentEnrollmentModel.empty(),
    );
  }
}