class MarkPaymentModel {
  final int id;
  final String? localUuid;
  final int studentId;
  final int studentClassEnrollmentId;
  final int? userId;
  final String markMethod;
  final double amount;
  final double discountAmount;
  final DateTime paidAt;
  final DateTime paymentMonth;
  final String paymentMethod;
  final String status;
  final String? receiptNumber;
  final String? referenceNumber;
  final bool isSynced;
  final String? note;
  final DateTime createdAt;
  final DateTime updatedAt;

  const MarkPaymentModel({
    required this.id,
    this.localUuid,
    required this.studentId,
    required this.studentClassEnrollmentId,
    this.userId,
    required this.markMethod,
    required this.amount,
    required this.discountAmount,
    required this.paidAt,
    required this.paymentMonth,
    required this.paymentMethod,
    required this.status,
    this.receiptNumber,
    this.referenceNumber,
    required this.isSynced,
    this.note,
    required this.createdAt,
    required this.updatedAt,
  });

  factory MarkPaymentModel.fromJson(Map<String, dynamic>? json) {
    return MarkPaymentModel(
      id: json?['id'] as int? ?? 0,
      localUuid: json?['local_uuid'] as String?,
      studentId: json?['student_id'] as int? ?? 0,
      studentClassEnrollmentId:
          json?['student_class_enrollment_id'] as int? ?? 0,
      userId: json?['user_id'] as int?,
      markMethod: json?['mark_method'] as String? ?? 'qr_mobile',
      amount: double.tryParse(json?['amount']?.toString() ?? '0') ?? 0,
      discountAmount:
          double.tryParse(json?['discount_amount']?.toString() ?? '0') ?? 0,
      paidAt: DateTime.tryParse(json?['paid_at']?.toString() ?? '') ??
          DateTime.now(),
      paymentMonth: DateTime.tryParse(json?['payment_month']?.toString() ?? '') ??
          DateTime.now(),
      paymentMethod: json?['payment_method'] as String? ?? 'cash',
      status: json?['status'] as String? ?? 'completed',
      receiptNumber: json?['receipt_number'] as String?,
      referenceNumber: json?['reference_number'] as String?,
      isSynced: json?['is_synced'] as bool? ?? true,
      note: json?['note'] as String?,
      createdAt: DateTime.tryParse(json?['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json?['updated_at']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'local_uuid': localUuid,
      'student_id': studentId,
      'student_class_enrollment_id': studentClassEnrollmentId,
      'user_id': userId,
      'mark_method': markMethod,
      'amount': amount,
      'discount_amount': discountAmount,
      'paid_at': paidAt.toIso8601String(),
      'payment_month': paymentMonth.toIso8601String(),
      'payment_method': paymentMethod,
      'status': status,
      'receipt_number': receiptNumber,
      'reference_number': referenceNumber,
      'is_synced': isSynced,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}