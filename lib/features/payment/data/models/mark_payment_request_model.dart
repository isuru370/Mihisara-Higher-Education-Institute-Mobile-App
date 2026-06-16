class MarkPaymentRequestModel {
  final List<MarkPaymentItemModel> payments;

  const MarkPaymentRequestModel({
    required this.payments,
  });

  factory MarkPaymentRequestModel.fromJson(Map<String, dynamic>? json) {
    final items = (json?['payments'] as List? ?? [])
        .map((e) => MarkPaymentItemModel.fromJson(e as Map<String, dynamic>?))
        .toList();

    return MarkPaymentRequestModel(payments: items);
  }

  Map<String, dynamic> toJson() {
    return {
      'payments': payments.map((e) => e.toJson()).toList(),
    };
  }
}

class MarkPaymentItemModel {
  final int studentId;
  final int studentClassEnrollmentId;
  final double amount;
  final double? discountAmount;
  final String paymentMonth;
  final DateTime? paidAt;
  final String? markMethod;
  final String? note;

  const MarkPaymentItemModel({
    required this.studentId,
    required this.studentClassEnrollmentId,
    required this.amount,
    this.discountAmount,
    required this.paymentMonth,
    this.paidAt,
    this.markMethod,
    this.note,
  });

  factory MarkPaymentItemModel.fromJson(Map<String, dynamic>? json) {
    return MarkPaymentItemModel(
      studentId: json?['student_id'] as int? ?? 0,
      studentClassEnrollmentId:
          json?['student_class_enrollment_id'] as int? ?? 0,
      amount: double.tryParse(json?['amount']?.toString() ?? '0') ?? 0,
      discountAmount: json?['discount_amount'] == null
          ? null
          : double.tryParse(json!['discount_amount'].toString()),
      paymentMonth: json?['payment_month'] as String? ?? '',
      paidAt: DateTime.tryParse(json?['paid_at']?.toString() ?? ''),
      markMethod: json?['mark_method'] as String?,
      note: json?['note'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'student_class_enrollment_id': studentClassEnrollmentId,
      'amount': amount,
      'discount_amount': discountAmount,
      'payment_month': paymentMonth,
      'paid_at': paidAt?.toIso8601String(),
      'mark_method': markMethod,
      'note': note,
    };
  }
}