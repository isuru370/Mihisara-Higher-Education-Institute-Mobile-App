import '../students_model.dart';

class CreateStudentResponseModel {
  final bool success;
  final String message;
  final StudentModel student;
  final AdmissionPaymentPrintModel? admissionPayment;

  const CreateStudentResponseModel({
    required this.success,
    required this.message,
    required this.student,
    this.admissionPayment,
  });

  factory CreateStudentResponseModel.fromJson(Map<String, dynamic> json) {
    return CreateStudentResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      student: StudentModel.fromJson(json['student'] as Map<String, dynamic>),
      admissionPayment: json['admission_payment'] != null
          ? AdmissionPaymentPrintModel.fromJson(
              json['admission_payment'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}

class AdmissionPaymentPrintModel {
  final int id;
  final String receiptNumber;
  final String amount;
  final String status;
  final String paidAt;
  final String paymentMethod;
  final String admissionName;

  const AdmissionPaymentPrintModel({
    required this.id,
    required this.receiptNumber,
    required this.amount,
    required this.status,
    required this.paidAt,
    required this.paymentMethod,
    required this.admissionName,
  });

  factory AdmissionPaymentPrintModel.fromJson(Map<String, dynamic> json) {
    return AdmissionPaymentPrintModel(
      id: json['id'] ?? 0,
      receiptNumber: json['receipt_number'] ?? '',
      amount: json['amount']?.toString() ?? '',
      status: json['status'] ?? '',
      paidAt: json['paid_at'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      admissionName: json['admission_name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'receipt_number': receiptNumber,
      'amount': amount,
      'status': status,
      'paid_at': paidAt,
      'payment_method': paymentMethod,
      'admission_name': admissionName,
    };
  }
}
