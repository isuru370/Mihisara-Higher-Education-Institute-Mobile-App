class MarkPaymentReceiptItemModel {
  final int paymentId;
  final String receiptNumber;
  final String referenceNumber;
  final String className;
  final String subject;
  final String categoryName;
  final String grade;
  final String teacher;
  final double amount;
  final double discountAmount;
  final String paidAt;

  const MarkPaymentReceiptItemModel({
    required this.paymentId,
    required this.receiptNumber,
    required this.referenceNumber,
    required this.className,
    required this.subject,
    required this.categoryName,
    required this.grade,
    required this.teacher,
    required this.amount,
    required this.discountAmount,
    required this.paidAt,
  });

  factory MarkPaymentReceiptItemModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return MarkPaymentReceiptItemModel(
      paymentId: json?['payment_id'] ?? 0,
      receiptNumber: json?['receipt_number'] ?? '',
      referenceNumber: json?['reference_number'] ?? '',
      className: json?['class_name'] ?? '',
      subject: json?['subject'] ?? '',
      categoryName: json?['category_name'] ?? '',
      grade: json?['grade'] ?? '',
      teacher: json?['teacher'] ?? '',
      amount: double.tryParse(json?['amount'].toString() ?? '0') ?? 0,
      discountAmount:
          double.tryParse(json?['discount_amount'].toString() ?? '0') ?? 0,
      paidAt: json?['paid_at'] ?? '',
    );
  }
}