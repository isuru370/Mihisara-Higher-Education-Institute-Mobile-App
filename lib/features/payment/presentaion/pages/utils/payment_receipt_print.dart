import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/printer_service.dart';

class PaymentReceiptPrint {
  const PaymentReceiptPrint._();

  static Future<void> printBulkReceipt({
    required PrinterService printerService,
    required String instituteName,
    required String studentName,
    required String studentId,
    required String paymentMonth,
    required List<PaymentReceiptItem> items,
    required double totalFee,
    required double discountAmount,
    required double payableTotal,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final bytes = await buildBulkReceiptData(
      instituteName: instituteName,
      studentName: studentName,
      studentId: studentId,
      paymentMonth: paymentMonth,
      items: items,
      totalFee: totalFee,
      discountAmount: discountAmount,
      payableTotal: payableTotal,
      paperSize: paperSize,
    );

    await printerService.printData(bytes);
  }

  static Future<List<int>> buildBulkReceiptData({
    required String instituteName,
    required String studentName,
    required String studentId,
    required String paymentMonth,
    required List<PaymentReceiptItem> items,
    required double totalFee,
    required double discountAmount,
    required double payableTotal,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);

    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(now);

    final bytes = <int>[];

    bytes.addAll(generator.reset());

    // HEADER
    bytes.addAll(
      generator.text(
        instituteName.toUpperCase(),
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
          height: PosTextSize.size2,
        ),
      ),
    );

    bytes.addAll(
      generator.text(
        'PAYMENT RECEIPT',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(generator.hr());

    // RECEIPT INFO
    bytes.addAll(generator.text('Date  : $formattedDate'));
    bytes.addAll(generator.text('Month : $paymentMonth'));

    bytes.addAll(generator.hr());

    // STUDENT DETAILS
    bytes.addAll(
      generator.text('STUDENT DETAILS', styles: const PosStyles(bold: true)),
    );

    bytes.addAll(generator.text('Name : $studentName'));
    bytes.addAll(generator.text('ID   : $studentId'));

    bytes.addAll(generator.hr());

    // ITEMS
    for (final item in items) {
      bytes.addAll(
        generator.text(item.className, styles: const PosStyles(bold: true)),
      );

      if (item.subject.isNotEmpty) {
        bytes.addAll(generator.text('Subject : ${item.subject}'));
      }

      if (item.categoryName.isNotEmpty) {
        bytes.addAll(generator.text('Category: ${item.categoryName}'));
      }

      if (item.grade.isNotEmpty) {
        bytes.addAll(generator.text('Grade   : ${item.grade}'));
      }

      if (item.teacherInitials.isNotEmpty) {
        bytes.addAll(generator.text('Teacher : ${item.teacherInitials}'));
      }

      bytes.addAll(
        generator.row([
          PosColumn(text: 'Amount', width: 6),
          PosColumn(
            text: 'LKR ${item.amount.toStringAsFixed(2)}',
            width: 6,
            styles: const PosStyles(align: PosAlign.right, bold: true),
          ),
        ]),
      );

      bytes.addAll(generator.hr(ch: '-'));
    }

    // SUMMARY
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'TOTAL FEE',
          width: 7,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: totalFee.toStringAsFixed(2),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'DISCOUNT',
          width: 7,
          styles: const PosStyles(bold: true),
        ),
        PosColumn(
          text: discountAmount.toStringAsFixed(2),
          width: 5,
          styles: const PosStyles(align: PosAlign.right),
        ),
      ]),
    );

    bytes.addAll(generator.hr());

    // GRAND TOTAL
    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(bold: true, height: PosTextSize.size2),
        ),
        PosColumn(
          text: payableTotal.toStringAsFixed(2),
          width: 6,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
            height: PosTextSize.size2,
          ),
        ),
      ]),
    );

    bytes.addAll(generator.hr());

    // FOOTER
    bytes.addAll(
      generator.text(
        'Thank You',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(
      generator.text(
        'Please keep this receipt',
        styles: const PosStyles(align: PosAlign.center),
      ),
    );

    bytes.addAll(generator.feed(1));
    bytes.addAll(generator.cut());

    return bytes;
  }
}

class PaymentReceiptItem {
  final String className;
  final String subject;
  final String categoryName;
  final String grade;
  final String teacherInitials;
  final double amount;

  const PaymentReceiptItem({
    required this.className,
    required this.subject,
    required this.categoryName,
    required this.grade,
    required this.teacherInitials,
    required this.amount,
  });
}
