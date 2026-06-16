import 'mark_payment_receipt_item_model.dart';

class MarkPaymentReceiptModel {
  final String paymentMonth;
  final double totalFee;
  final double discountAmount;
  final double payableTotal;
  final List<MarkPaymentReceiptItemModel> items;

  const MarkPaymentReceiptModel({
    required this.paymentMonth,
    required this.totalFee,
    required this.discountAmount,
    required this.payableTotal,
    required this.items,
  });

  factory MarkPaymentReceiptModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return MarkPaymentReceiptModel(
      paymentMonth: json?['payment_month'] ?? '',
      totalFee:
          double.tryParse(json?['total_fee'].toString() ?? '0') ?? 0,
      discountAmount:
          double.tryParse(json?['discount_amount'].toString() ?? '0') ?? 0,
      payableTotal:
          double.tryParse(json?['payable_total'].toString() ?? '0') ?? 0,
      items: (json?['items'] as List? ?? [])
          .map(
            (e) => MarkPaymentReceiptItemModel.fromJson(
              e as Map<String, dynamic>?,
            ),
          )
          .toList(),
    );
  }
}