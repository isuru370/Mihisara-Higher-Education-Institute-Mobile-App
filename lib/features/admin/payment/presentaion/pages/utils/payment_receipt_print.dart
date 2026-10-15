import 'package:esc_pos_utils_plus/esc_pos_utils_plus.dart';
import 'package:intl/intl.dart';

import '../../../../../../core/utils/printer_service.dart';

class PaymentReceiptPrint {
  const PaymentReceiptPrint._();

  static Future<void> printReceipt({
    required PrinterService printerService,
    required String instituteName,
    required String studentName,
    required String studentId,
    required String paymentMonth,
    required String paymentMethod,
    required List<ReceiptClassDetail> classes,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final bytes = await buildReceiptData(
      instituteName: instituteName,
      studentName: studentName,
      studentId: studentId,
      paymentMonth: paymentMonth,
      paymentMethod: paymentMethod,
      classes: classes,
      paperSize: paperSize,
    );

    await printerService.printData(bytes);
  }

  static Future<List<int>> buildReceiptData({
    required String instituteName,
    required String studentName,
    required String studentId,
    required String paymentMonth,
    required String paymentMethod,
    required List<ReceiptClassDetail> classes,
    PaperSize paperSize = PaperSize.mm58,
  }) async {
    final profile = await CapabilityProfile.load();

    final generator = Generator(
      paperSize,
      profile,
    );

    final now = DateTime.now();

    final formattedDate = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(now);

    final bytes = <int>[];

    bytes.addAll(
      generator.reset(),
    );

    // =========================================================
    // HEADER
    // =========================================================

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
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      ),
    );

    bytes.addAll(
      generator.hr(),
    );

    // =========================================================
    // RECEIPT INFO
    // =========================================================

    bytes.addAll(
      generator.text(
        'Date  : $formattedDate',
      ),
    );

    bytes.addAll(
      generator.text(
        'Month : $paymentMonth',
      ),
    );

    bytes.addAll(
      generator.text(
        'Method: ${paymentMethod.toUpperCase()}',
      ),
    );

    bytes.addAll(
      generator.hr(),
    );

    // =========================================================
    // STUDENT DETAILS
    // =========================================================

    bytes.addAll(
      generator.text(
        'STUDENT DETAILS',
        styles: const PosStyles(
          bold: true,
        ),
      ),
    );

    bytes.addAll(
      generator.text(
        'Name : $studentName',
      ),
    );

    bytes.addAll(
      generator.text(
        'ID   : $studentId',
      ),
    );

    bytes.addAll(
      generator.hr(),
    );

    // =========================================================
    // CLASS DETAILS
    // =========================================================

    for (final item in classes) {
      // -------------------------------------------------------
      // Class
      // -------------------------------------------------------

      if (item.className.isNotEmpty) {
        bytes.addAll(
          generator.text(
            item.className,
            styles: const PosStyles(
              bold: true,
            ),
          ),
        );
      }

      // -------------------------------------------------------
      // Grade
      // -------------------------------------------------------

      if (item.grade.isNotEmpty) {
        bytes.addAll(
          generator.text(
            'Grade   : ${item.grade}',
          ),
        );
      }

      // -------------------------------------------------------
      // Teacher
      // -------------------------------------------------------

      if (item.teacherName.isNotEmpty) {
        bytes.addAll(
          generator.text(
            'Teacher : ${item.teacherName}',
          ),
        );
      }

      // -------------------------------------------------------
      // Category
      // -------------------------------------------------------

      if (item.categoryName.isNotEmpty) {
        bytes.addAll(
          generator.text(
            'Category: ${item.categoryName}',
          ),
        );
      }

      // -------------------------------------------------------
      // Fee Option
      // -------------------------------------------------------

      if (item.feeOptionName.isNotEmpty) {
        bytes.addAll(
          generator.text(
            'Option  : ${item.feeOptionName}',
          ),
        );
      }

      // -------------------------------------------------------
      // Receipt Number
      // -------------------------------------------------------

      if (item.receiptNumber.isNotEmpty) {
        bytes.addAll(
          generator.text(
            'Receipt : ${item.receiptNumber}',
          ),
        );
      }

      // -------------------------------------------------------
      // Class Fee
      // -------------------------------------------------------

      bytes.addAll(
        generator.row([
          PosColumn(
            text: 'Amount',
            width: 6,
          ),
          PosColumn(
            text: 'LKR ${item.classFee.toStringAsFixed(2)}',
            width: 6,
            styles: const PosStyles(
              align: PosAlign.right,
              bold: true,
            ),
          ),
        ]),
      );

      bytes.addAll(
        generator.hr(
          ch: '-',
        ),
      );
    }

    // =========================================================
    // SUMMARY
    // =========================================================

    final total = classes.fold<double>(
      0,
      (sum, item) => sum + item.classFee,
    );

    bytes.addAll(
      generator.row([
        PosColumn(
          text: 'TOTAL FEE',
          width: 7,
          styles: const PosStyles(
            bold: true,
          ),
        ),
        PosColumn(
          text: 'LKR ${total.toStringAsFixed(2)}',
          width: 5,
          styles: const PosStyles(
            align: PosAlign.right,
            bold: true,
          ),
        ),
      ]),
    );

    bytes.addAll(
      generator.hr(),
    );

    // =========================================================
    // PAYMENT COUNT
    // =========================================================

    bytes.addAll(
      generator.text(
        'Classes Paid : ${classes.length}',
      ),
    );

    // =========================================================
    // FOOTER
    // =========================================================

    bytes.addAll(
      generator.hr(),
    );

    bytes.addAll(
      generator.text(
        'Thank You',
        styles: const PosStyles(
          align: PosAlign.center,
          bold: true,
        ),
      ),
    );

    bytes.addAll(
      generator.text(
        'Please keep this receipt',
        styles: const PosStyles(
          align: PosAlign.center,
        ),
      ),
    );

    bytes.addAll(
      generator.feed(1),
    );

    bytes.addAll(
      generator.cut(),
    );

    return bytes;
  }
}


// =============================================================
// RECEIPT CLASS DETAIL
// =============================================================

class ReceiptClassDetail {
  final String className;
  final String grade;
  final String teacherName;
  final String categoryName;
  final String feeOptionName;
  final double classFee;
  final String receiptNumber;

  const ReceiptClassDetail({
    required this.className,
    required this.grade,
    required this.teacherName,
    required this.categoryName,
    required this.feeOptionName,
    required this.classFee,
    required this.receiptNumber,
  });
}