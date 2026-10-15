import 'package:intl/intl.dart';

class AdmissionPaymentModel {
  final int paymentId;
  final String receiptNumber;

  final int studentId;
  final String studentCode;
  final String studentName;
  final String grade;
  final String guardianMobile;

  final int admissionId;
  final String admissionName;
  final String admissionAmount;

  final String amount;
  final String paymentMethod;
  final String status;
  final String paidAt;
  final String collectedBy;
  final String note;

  const AdmissionPaymentModel({
    required this.paymentId,
    required this.receiptNumber,
    required this.studentId,
    required this.studentCode,
    required this.studentName,
    required this.grade,
    required this.guardianMobile,
    required this.admissionId,
    required this.admissionName,
    required this.admissionAmount,
    required this.amount,
    required this.paymentMethod,
    required this.status,
    required this.paidAt,
    required this.collectedBy,
    required this.note,
  });

  factory AdmissionPaymentModel.fromJson(Map<String, dynamic> json) {
    return AdmissionPaymentModel(
      paymentId: json['payment_id'] ?? 0,
      receiptNumber: json['receipt_number'] ?? '',

      studentId: json['student']?['id'] ?? 0,
      studentCode: json['student']?['custom_id'] ?? '',
      studentName: json['student']?['name'] ?? '',
      grade: json['student']?['grade'] ?? '',
      guardianMobile: json['student']?['guardian_mobile'] ?? '',

      admissionId: json['admission']?['id'] ?? 0,
      admissionName: json['admission']?['name'] ?? '',
      admissionAmount: json['admission']?['amount']?.toString() ?? '0.00',

      amount: json['payment']?['amount']?.toString() ?? '0.00',

      paymentMethod: json['payment']?['payment_method'] ?? '',

      status: json['payment']?['status'] ?? '',

      paidAt: json['payment']?['paid_at'] ?? '',

      collectedBy: json['payment']?['collected_by'] ?? '',

      note: json['payment']?['note'] ?? '',
    );
  }

  String get formattedPaidAt {
    try {
      return DateFormat(
        'yyyy-MM-dd HH:mm',
      ).format(DateTime.parse(paidAt).toLocal());
    } catch (_) {
      return paidAt;
    }
  }
}
