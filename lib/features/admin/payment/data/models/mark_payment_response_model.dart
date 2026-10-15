import 'mark_payment_model.dart';
import 'mark_payment_receipt_model.dart';

class MarkPaymentResponseModel {
  final List<MarkPaymentModel> payments;
  final MarkPaymentReceiptModel receipt;
  final int count;

  final double totalFinalFee;
  final double totalHallFee;
  final double totalGrossFee;
  final double totalDiscount;
  final double totalPayable;
  final double totalPaid;
  final double totalBalance;
  final String paidAt;

  const MarkPaymentResponseModel({
    required this.payments,
    required this.receipt,
    required this.count,
    required this.totalFinalFee,
    required this.totalHallFee,
    required this.totalGrossFee,
    required this.totalDiscount,
    required this.totalPayable,
    required this.totalPaid,
    required this.totalBalance,
    required this.paidAt,
  });

  factory MarkPaymentResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    final paymentsJson = json['payments'];

    final List<MarkPaymentModel> payments = [];

    if (paymentsJson is List) {
      for (final item in paymentsJson) {
        if (item is Map<String, dynamic>) {
          payments.add(
            MarkPaymentModel.fromJson(item),
          );
        }
      }
    }

    final receiptJson = json['receipt'];

    return MarkPaymentResponseModel(
      payments: payments,

      receipt: receiptJson is Map<String, dynamic>
          ? MarkPaymentReceiptModel.fromJson(receiptJson)
          : MarkPaymentReceiptModel.empty(),

      count: int.tryParse(
            json['count']?.toString() ?? '0',
          ) ??
          0,

      totalFinalFee: _toDouble(
        json['total_final_fee'],
      ),

      totalHallFee: _toDouble(
        json['total_hall_fee'],
      ),

      totalGrossFee: _toDouble(
        json['total_gross_fee'],
      ),

      totalDiscount: _toDouble(
        json['total_discount'],
      ),

      totalPayable: _toDouble(
        json['total_payable'],
      ),

      totalPaid: _toDouble(
        json['total_paid'],
      ),

      totalBalance: _toDouble(
        json['total_balance'],
      ),

      paidAt:
          json['paid_at']?.toString() ?? '',
    );
  }

  static double _toDouble(dynamic value) {
    return double.tryParse(
          value?.toString() ?? '0',
        ) ??
        0.0;
  }
}