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

  /// Reads the receipt sent by /new-payment/bulk-pay:
  ///   { student: {custom_id, initial_name, full_name}, payment_method,
  ///     rows: [{class_name, category, grade, teacher, receipt_number,
  ///             class_fee, ...}], summary: {total_class_fee} }
  /// The old keys (student_details, classes, total, payment_count) are
  /// still accepted. Before this, rows were never read, so classes was
  /// always empty and the receipt was never printed.
  factory MarkPaymentReceiptModel.fromJson(Map<String, dynamic> json) {
    final studentJson = json['student_details'] ?? json['student'];

    final classesJson = json['classes'] ?? json['rows'];

    final summary = json['summary'] is Map<String, dynamic>
        ? json['summary'] as Map<String, dynamic>
        : const <String, dynamic>{};

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

      total: double.tryParse(
            (json['total'] ?? summary['total_class_fee'])?.toString() ?? '',
          ) ??
          classes.fold<double>(0, (sum, item) => sum + item.classFee),

      paymentMethod: json['payment_method']?.toString() ?? '',

      paymentCount: int.tryParse(json['payment_count']?.toString() ?? '') ??
          classes.length,
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
