import 'payment_model.dart';
import 'student_class_enrollment_summary_model.dart';
import 'student_class_summary_model.dart';
import 'student_summary_model.dart';

class TodayPaymentItemModel {
  final PaymentModel payment;
  final StudentSummaryModel student;
  final StudentClassEnrollmentSummaryModel studentClassEnrollment;
  final StudentClassSummaryModel studentClass;

  TodayPaymentItemModel({
    required this.payment,
    required this.student,
    required this.studentClassEnrollment,
    required this.studentClass,
  });

  factory TodayPaymentItemModel.fromJson(Map<String, dynamic> json) {
    return TodayPaymentItemModel(
      payment: PaymentModel.fromJson(json['payment'] as Map<String, dynamic>),
      student: StudentSummaryModel.fromJson(json['student'] as Map<String, dynamic>),
      studentClassEnrollment: StudentClassEnrollmentSummaryModel.fromJson(
        json['student_class_enrollment'] as Map<String, dynamic>,
      ),
      studentClass: StudentClassSummaryModel.fromJson(
        json['student_class'] as Map<String, dynamic>,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'payment': payment.toJson(),
      'student': student.toJson(),
      'student_class_enrollment': studentClassEnrollment.toJson(),
      'student_class': studentClass.toJson(),
    };
  }
}