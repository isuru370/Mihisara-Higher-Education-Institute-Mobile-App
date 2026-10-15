import '../../../../qr/data/model/read_payment/read_student_class_payment_model.dart';

class PaymentDiscountResult {
  final int selectedCount;
  final double totalFee;
  final double discountAmount;
  final double payableTotal;
  final double perClassDiscount;
  final bool discountApplied;

  const PaymentDiscountResult({
    required this.selectedCount,
    required this.totalFee,
    required this.discountAmount,
    required this.payableTotal,
    required this.perClassDiscount,
    required this.discountApplied,
  });
}

class PaymentDiscountCalculator {
  static PaymentDiscountResult calculate({
    required List<ReadStudentClassPaymentModel> selectedPayments,
    int minimumClassesForDiscount = 5,
    double discountRate = 0.10,
  }) {
    final selectedCount = selectedPayments.length;
    final totalFee = selectedPayments.fold<double>(
      0,
      (sum, item) => sum + item.finalFee.toDouble(),
    );

    final discountApplied = selectedCount >= minimumClassesForDiscount;
    final discountAmount = discountApplied ? totalFee * discountRate : 0.0;
    final perClassDiscount =
        discountApplied && selectedCount > 0 ? discountAmount / selectedCount : 0.0;
    final payableTotal = totalFee - discountAmount;

    return PaymentDiscountResult(
      selectedCount: selectedCount,
      totalFee: totalFee,
      discountAmount: discountAmount,
      payableTotal: payableTotal,
      perClassDiscount: perClassDiscount,
      discountApplied: discountApplied,
    );
  }
}
