import 'mark_payment_receipt_item_model.dart';
import 'mark_payment_student_model.dart';

class MarkPaymentReceiptModel {
  final MarkPaymentStudentModel studentDetails;
  final List<MarkPaymentReceiptItemModel> classes;
  final double total;
  final String paymentMethod;
  final int paymentCount;

  const MarkPaymentReceiptModel({
    required this.studentDetails,
    required this.classes,
    required this.total,
    required this.paymentMethod,
    required this.paymentCount,
  });

  factory MarkPaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    final studentJson = json['student_details'];

    final classesJson = json['classes'];

    final List<MarkPaymentReceiptItemModel> classes = [];

    if (classesJson is List) {
      for (final item in classesJson) {
        if (item is Map<String, dynamic>) {
          classes.add(MarkPaymentReceiptItemModel.fromJson(item));
        }
      }
    }

    return MarkPaymentReceiptModel(
      studentDetails: studentJson is Map<String, dynamic>
          ? MarkPaymentStudentModel.fromJson(studentJson)
          : MarkPaymentStudentModel.empty(),

      classes: classes,

      total: double.tryParse(json['total']?.toString() ?? '0') ?? 0.0,

      paymentMethod: json['payment_method']?.toString() ?? '',

      paymentCount: int.tryParse(json['payment_count']?.toString() ?? '0') ?? 0,
    );
  }

  factory MarkPaymentReceiptModel.empty() {
    return MarkPaymentReceiptModel(
      studentDetails: MarkPaymentStudentModel.empty(),
      classes: const [],
      total: 0.0,
      paymentMethod: '',
      paymentCount: 0,
    );
  }
}
