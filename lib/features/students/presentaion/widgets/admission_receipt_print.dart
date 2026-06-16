import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

import '../../../../../core/utils/printer_service.dart';

class AdmissionReceiptPrint {
  const AdmissionReceiptPrint._();

  static Future<void> printReceipt({
    required PrinterService printerService,
    required String instituteName,
    required String receiptNumber,
    required String studentName,
    required String studentId,
    required String admissionName,
    required double amount,
    required String paymentMethod,
    required String paidAt,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final bytes = await buildReceiptData(
      instituteName: instituteName,
      receiptNumber: receiptNumber,
      studentName: studentName,
      studentId: studentId,
      admissionName: admissionName,
      amount: amount,
      paymentMethod: paymentMethod,
      paidAt: paidAt,
      paperSize: paperSize,
    );

    await printerService.printData(bytes);
  }

  static Future<List<int>> buildReceiptData({
    required String instituteName,
    required String receiptNumber,
    required String studentName,
    required String studentId,
    required String admissionName,
    required double amount,
    required String paymentMethod,
    required String paidAt,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();
    final generator = Generator(paperSize, profile);

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
        'ADMISSION RECEIPT',
        styles: const PosStyles(align: PosAlign.center, bold: true),
      ),
    );

    bytes.addAll(generator.hr());

    // RECEIPT INFO

    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm:ss',
    ).format(DateTime.parse(DateTime.now().toString()));

    bytes.addAll(generator.text('Receipt No : $receiptNumber'));

    bytes.addAll(generator.text('Date       : $formattedDate'));

    bytes.addAll(generator.hr());

    // STUDENT DETAILS

    bytes.addAll(
      generator.text('STUDENT DETAILS', styles: const PosStyles(bold: true)),
    );

    bytes.addAll(generator.text('Name : $studentName'));

    bytes.addAll(generator.text('ID   : $studentId'));

    bytes.addAll(generator.hr());

    // ADMISSION DETAILS

    bytes.addAll(
      generator.text('ADMISSION DETAILS', styles: const PosStyles(bold: true)),
    );

    bytes.addAll(generator.text('Admission : $admissionName'));

    bytes.addAll(generator.text('Method    : $paymentMethod'));

    bytes.addAll(generator.hr());

    // AMOUNT

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'TOTAL',
          width: 6,
          styles: const PosStyles(bold: true, height: PosTextSize.size2),
        ),
        PosColumn(
          text: amount.toStringAsFixed(2),
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

    bytes.addAll(generator.feed(2));
    bytes.addAll(generator.cut());

    return bytes;
  }
}
