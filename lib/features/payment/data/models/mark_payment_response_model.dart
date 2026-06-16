import 'mark_payment_receipt_model.dart';
import 'mark_payment_student_model.dart';

class MarkPaymentResponseDataModel {
  final MarkPaymentStudentModel student;
  final MarkPaymentReceiptModel receipt;
  final int count;

  const MarkPaymentResponseDataModel({
    required this.student,
    required this.receipt,
    required this.count,
  });

  factory MarkPaymentResponseDataModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return MarkPaymentResponseDataModel(
      student: MarkPaymentStudentModel.fromJson(
        json?['student'] as Map<String, dynamic>?,
      ),
      receipt: MarkPaymentReceiptModel.fromJson(
        json?['receipt'] as Map<String, dynamic>?,
      ),
      count: json?['count'] ?? 0,
    );
  }
}