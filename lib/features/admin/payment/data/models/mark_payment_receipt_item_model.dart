class MarkPaymentReceiptItemModel {
  final String className;
  final String grade;
  final String teacherName;
  final String categoryName;
  final String feeOptionName;
  final double classFee;
  final String receiptNumber;

  const MarkPaymentReceiptItemModel({
    required this.className,
    required this.grade,
    required this.teacherName,
    required this.categoryName,
    required this.feeOptionName,
    required this.classFee,
    required this.receiptNumber,
  });

  factory MarkPaymentReceiptItemModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return MarkPaymentReceiptItemModel(
      className:
          json['class_name']?.toString() ?? '',

      grade:
          json['grade']?.toString() ?? '',

      teacherName:
          (json['teacher_name'] ?? json['teacher'])?.toString() ?? '',

      categoryName:
          (json['category_name'] ?? json['category'])?.toString() ?? '',

      feeOptionName:
          (json['fee_option_name'] ?? json['fee_option'])?.toString() ?? '',

      classFee: double.tryParse(
            json['class_fee']?.toString() ?? '0',
          ) ??
          0.0,

      receiptNumber:
          (json['receipt_no'] ?? json['receipt_number'])?.toString() ?? '',
    );
  }
}