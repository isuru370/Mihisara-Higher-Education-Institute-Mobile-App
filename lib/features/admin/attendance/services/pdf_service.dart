import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../data/models/attendance_report/attendance_report_response_model.dart';
import '../data/models/attendance_report/student_data.dart';

class PdfService {
  static Future<void> generateAndSharePdf(
    AttendanceReportResponseModel data,
  ) async {
    try {
      final pdf = await _generatePdf(data);
      final output = await getTemporaryDirectory();
      final filePath =
          '${output.path}/attendance_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdf);

      await SharePlus.instance.share(
        ShareParams(files: [XFile(filePath)], text: 'Attendance Report'),
      );
    } catch (e) {
      throw Exception('Failed to generate PDF: $e');
    }
  }

  static Future<Uint8List> _generatePdf(
    AttendanceReportResponseModel data,
  ) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(30),
        build: (context) {
          return [
            _buildHeader(data),
            _buildScheduleInfo(data),
            _buildSummary(data),
            _buildStudentsList(data),
            _buildFooter(),
          ];
        },
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _buildHeader(AttendanceReportResponseModel data) {
    return pw.Container(
      width: double.infinity,
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.symmetric(vertical: 25, horizontal: 20),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue900,
        borderRadius: pw.BorderRadius.circular(10),
      ),
      child: pw.Column(
        mainAxisAlignment: pw.MainAxisAlignment.center,
        crossAxisAlignment: pw.CrossAxisAlignment.center,
        children: [
          pw.Text(
            'ATTENDANCE REPORT',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 24,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Text(
            data.data.schedule.studentClass.className,
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.white,
            ),
          ),
          pw.SizedBox(height: 5),
          pw.Text(
            'Generated : ${DateTime.now().toString().split(' ')[0]}',
            textAlign: pw.TextAlign.center,
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey300),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildScheduleInfo(AttendanceReportResponseModel data) {
    final schedule = data.data.schedule;
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 16),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'SCHEDULE INFORMATION',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
              letterSpacing: 1,
            ),
          ),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('Class', schedule.studentClass.className),
              _buildInfoItem(
                'Category',
                schedule.classCategoryFee.category.categoryName,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('Date', schedule.classDate.split('T')[0]),
              _buildInfoItem(
                'Time',
                '${schedule.startTime} - ${schedule.endTime}',
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem(
                'Status',
                schedule.status.toUpperCase(),
                color: _getStatusColor(schedule.status),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoItem(
    String label,
    String value, {
    PdfColor? color,
  }) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: color ?? PdfColors.black,
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummary(AttendanceReportResponseModel data) {
    final summary = data.data.summary;
    return pw.Container(
      margin: const pw.EdgeInsets.all(16),
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'SUMMARY',
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
              letterSpacing: 1,
            ),
          ),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Total',
                summary.totalStudents.toString(),
                PdfColors.blue,
              ),
              _buildSummaryItem(
                'Present',
                summary.presentStudents.toString(),
                PdfColors.green,
              ),
              _buildSummaryItem(
                'Absent',
                summary.absentStudents.toString(),
                PdfColors.red,
              ),
            ],
          ),
          pw.SizedBox(height: 12),
          pw.Divider(color: PdfColors.grey200),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Paid',
                summary.paidStudents.toString(),
                PdfColors.blue,
              ),
              _buildSummaryItem(
                'Unpaid',
                summary.unpaidStudents.toString(),
                PdfColors.orange,
              ),
              _buildSummaryItem(
                'Attendance',
                '${summary.attendancePercentage}%',
                summary.attendancePercentage >= 80
                    ? PdfColors.green
                    : PdfColors.orange,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                'Payment',
                '${summary.paymentPercentage}%',
                summary.paymentPercentage >= 50
                    ? PdfColors.green
                    : PdfColors.orange,
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(
    String label,
    String value,
    PdfColor color,
  ) {
    return pw.Column(
      children: [
        pw.Text(
          value,
          style: pw.TextStyle(
            fontSize: 18,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static pw.Widget _buildStudentsList(AttendanceReportResponseModel data) {
    // Filter students into present and absent
    final presentStudents = data.data.students
        .where((s) => s.attendance.isPresent)
        .toList();

    final absentStudents = data.data.students
        .where((s) => !s.attendance.isPresent)
        .toList();

    // Sort present students - paid first
    presentStudents.sort((a, b) {
      if (a.payment.isPaid == b.payment.isPaid) return 0;
      return a.payment.isPaid ? -1 : 1;
    });

    // Sort absent students - paid first
    absentStudents.sort((a, b) {
      if (a.payment.isPaid == b.payment.isPaid) return 0;
      return a.payment.isPaid ? -1 : 1;
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Present Students Section
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal: 16),
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: PdfColors.green50,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            children: [
              pw.Text(
                'PRESENT STUDENTS (${presentStudents.length})',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        if (presentStudents.isNotEmpty)
          _buildStudentTable(presentStudents, isPresent: true)
        else
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 16),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'No present students',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),

        pw.SizedBox(height: 20),

        // Absent Students Section
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal: 16),
          padding: const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          decoration: pw.BoxDecoration(
            color: PdfColors.red50,
            borderRadius: pw.BorderRadius.circular(6),
          ),
          child: pw.Row(
            children: [
              pw.Text(
                'ABSENT STUDENTS (${absentStudents.length})',
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red700,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        if (absentStudents.isNotEmpty)
          _buildStudentTable(absentStudents, isPresent: false)
        else
          pw.Container(
            margin: const pw.EdgeInsets.symmetric(horizontal: 16),
            padding: const pw.EdgeInsets.all(12),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(color: PdfColors.grey300),
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pw.Text(
              'No absent students',
              style: pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey600,
                fontStyle: pw.FontStyle.italic,
              ),
            ),
          ),

        pw.SizedBox(height: 20),

        // Payment Details Section (Paid Students)
        _buildPaymentDetails(data.data.students),

        pw.SizedBox(height: 16),

        // Attendance Details Section
        _buildAttendanceDetails(data.data.students),
      ],
    );
  }

  static pw.Widget _buildStudentTable(
    List<StudentData> students, {
    required bool isPresent,
  }) {
    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
      children: [
        // Header Row
        pw.TableRow(
          decoration: pw.BoxDecoration(
            color: isPresent ? PdfColors.green700 : PdfColors.red700,
          ),
          children: [
            _buildTableHeader('No', color: PdfColors.white),
            _buildTableHeader('Student Code', color: PdfColors.white),
            _buildTableHeader('Student Name', color: PdfColors.white),
            _buildTableHeader('Grade', color: PdfColors.white),
            _buildTableHeader('Contact', color: PdfColors.white),
            _buildTableHeader('Status', color: PdfColors.white),
            _buildTableHeader('Payment', color: PdfColors.white),
          ],
        ),
        // Data Rows
        ...students.asMap().entries.map((entry) {
          final index = entry.key;
          final student = entry.value;
          final isPaid = student.payment.isPaid;
          final rowColor = index % 2 == 0 ? PdfColors.grey50 : PdfColors.white;

          return pw.TableRow(
            decoration: pw.BoxDecoration(color: rowColor),
            children: [
              _buildTableCell('${index + 1}'),
              _buildTableCell(student.student.studentCode),
              _buildTableCell(student.student.initialName),
              _buildTableCell('Grade ${student.student.grade}'),
              _buildTableCell(student.student.guardianMobile),
              _buildTableCell(
                isPresent ? 'Present' : 'Absent',
                color: isPresent ? PdfColors.green : PdfColors.red,
              ),
              _buildTableCell(
                isPaid ? 'Paid' : 'Unpaid',
                color: isPaid ? PdfColors.blue : PdfColors.orange,
              ),
            ],
          );
        }),
      ],
    );
  }

  static pw.Widget _buildPaymentDetails(List<StudentData> students) {
    final paidStudents = students.where((s) => s.payment.isPaid).toList();
    final unpaidStudents = students.where((s) => !s.payment.isPaid).toList();

    // Sort paid students by payment month
    paidStudents.sort((a, b) {
      if (a.payment.paymentMonth == null) return 1;
      if (b.payment.paymentMonth == null) return -1;
      return a.payment.paymentMonth!.compareTo(b.payment.paymentMonth!);
    });

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        // Paid Students
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal: 16),
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.green200),
            borderRadius: pw.BorderRadius.circular(8),
            color: PdfColors.green50,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'PAID STUDENTS (${paidStudents.length})',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green700,
                ),
              ),
              pw.Divider(color: PdfColors.green200),
              pw.SizedBox(height: 6),
              if (paidStudents.isNotEmpty)
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.green200,
                    width: 0.3,
                  ),
                  children: [
                    // Sub Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.green100),
                      children: [
                        _buildTableHeader(
                          'Student Code',
                          color: PdfColors.green700,
                        ),
                        _buildTableHeader(
                          'Student Name',
                          color: PdfColors.green700,
                        ),
                        _buildTableHeader('Amount', color: PdfColors.green700),
                        _buildTableHeader('Month', color: PdfColors.green700),
                        _buildTableHeader(
                          'Receipt No',
                          color: PdfColors.green700,
                        ),
                        _buildTableHeader('Status', color: PdfColors.green700),
                      ],
                    ),
                    ...paidStudents.map((student) {
                      return pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.white),
                        children: [
                          _buildTableCell(student.student.studentCode),
                          _buildTableCell(student.student.initialName),
                          _buildTableCell(
                            'Rs ${student.payment.amount?.toStringAsFixed(2) ?? '0.00'}',
                            color: PdfColors.green,
                          ),
                          _buildTableCell(
                            _formatPaymentMonth(student.payment.paymentMonth),
                          ),
                          _buildTableCell(
                            student.payment.receiptNumber ?? 'N/A',
                          ),
                          _buildTableCell(
                            student.attendance.isPresent ? 'Present' : 'Absent',
                            color: student.attendance.isPresent
                                ? PdfColors.green
                                : PdfColors.red,
                          ),
                        ],
                      );
                    }),
                  ],
                )
              else
                pw.Text(
                  'No paid students found',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),

        pw.SizedBox(height: 12),

        // Unpaid Students
        pw.Container(
          margin: const pw.EdgeInsets.symmetric(horizontal: 16),
          padding: const pw.EdgeInsets.all(12),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(color: PdfColors.orange200),
            borderRadius: pw.BorderRadius.circular(8),
            color: PdfColors.orange50,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'UNPAID STUDENTS (${unpaidStudents.length})',
                style: pw.TextStyle(
                  fontSize: 13,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange700,
                ),
              ),
              pw.Divider(color: PdfColors.orange200),
              pw.SizedBox(height: 6),
              if (unpaidStudents.isNotEmpty)
                pw.Table(
                  border: pw.TableBorder.all(
                    color: PdfColors.orange200,
                    width: 0.3,
                  ),
                  children: [
                    // Sub Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.orange100),
                      children: [
                        _buildTableHeader(
                          'Student Code',
                          color: PdfColors.orange700,
                        ),
                        _buildTableHeader(
                          'Student Name',
                          color: PdfColors.orange700,
                        ),
                        _buildTableHeader('Amount', color: PdfColors.orange700),
                        _buildTableHeader('Status', color: PdfColors.orange700),
                      ],
                    ),
                    ...unpaidStudents.map((student) {
                      return pw.TableRow(
                        decoration: pw.BoxDecoration(color: PdfColors.white),
                        children: [
                          _buildTableCell(student.student.studentCode),
                          _buildTableCell(student.student.initialName),
                          _buildTableCell(
                            'Rs ${student.payment.amount?.toStringAsFixed(2) ?? '0.00'}',
                            color: PdfColors.orange,
                          ),
                          _buildTableCell(
                            student.attendance.isPresent ? 'Present' : 'Absent',
                            color: student.attendance.isPresent
                                ? PdfColors.green
                                : PdfColors.red,
                          ),
                        ],
                      );
                    }),
                  ],
                )
              else
                pw.Text(
                  'No unpaid students',
                  style: pw.TextStyle(
                    fontSize: 10,
                    color: PdfColors.grey600,
                    fontStyle: pw.FontStyle.italic,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildAttendanceDetails(List<StudentData> students) {
    return pw.Container(
      margin: const pw.EdgeInsets.symmetric(horizontal: 16),
      padding: const pw.EdgeInsets.all(12),
      decoration: pw.BoxDecoration(
        border: pw.Border.all(color: PdfColors.grey300),
        borderRadius: pw.BorderRadius.circular(8),
        color: PdfColors.grey50,
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'ATTENDANCE DETAILS',
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
              color: PdfColors.blue700,
              letterSpacing: 0.5,
            ),
          ),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Table(
            border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.3),
            children: [
              // Sub Header
              pw.TableRow(
                decoration: pw.BoxDecoration(color: PdfColors.blue100),
                children: [
                  _buildTableHeader('Student Code', color: PdfColors.blue700),
                  _buildTableHeader('Student Name', color: PdfColors.blue700),
                  _buildTableHeader('Attendance', color: PdfColors.blue700),
                  _buildTableHeader('Attended At', color: PdfColors.blue700),
                  _buildTableHeader('Payment', color: PdfColors.blue700),
                ],
              ),
              ...students.map((student) {
                final isPresent = student.attendance.isPresent;
                final attendedAt = student.attendance.attendedAt;
                return pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.white),
                  children: [
                    _buildTableCell(student.student.studentCode),
                    _buildTableCell(student.student.initialName),
                    _buildTableCell(
                      isPresent ? 'Present' : 'Absent',
                      color: isPresent ? PdfColors.green : PdfColors.red,
                    ),
                    _buildTableCell(
                      attendedAt != null
                          ? _formatTimeForPdf(attendedAt)
                          : 'N/A',
                    ),
                    _buildTableCell(
                      student.payment.isPaid ? 'Paid' : 'Unpaid',
                      color: student.payment.isPaid
                          ? PdfColors.blue
                          : PdfColors.orange,
                    ),
                  ],
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildTableHeader(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
          color: color ?? PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(5),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 8.5, color: color ?? PdfColors.black),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildFooter() {
    return pw.Container(
      margin: const pw.EdgeInsets.all(16),
      padding: const pw.EdgeInsets.all(12),
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Nexorait Education System',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
              pw.Text(
                'Generated: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'This is a computer-generated report. No signature required.',
            style: pw.TextStyle(
              fontSize: 8,
              color: PdfColors.grey500,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
          pw.SizedBox(height: 2),
          pw.Text(
            'Report ID: ${DateTime.now().millisecondsSinceEpoch}',
            style: pw.TextStyle(fontSize: 7, color: PdfColors.grey400),
          ),
        ],
      ),
    );
  }

  static String _formatPaymentMonth(String? paymentMonth) {
    if (paymentMonth == null || paymentMonth.isEmpty) return 'N/A';

    try {
      // Try to parse the date
      final date = DateTime.parse(paymentMonth);
      // Format as YYYY-MM
      return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    } catch (e) {
      // If parsing fails, try to extract year and month from string
      try {
        // Check if it's in format "2024-01-01" or similar
        final parts = paymentMonth.split('-');
        if (parts.length >= 2) {
          final year = parts[0];
          final month = parts[1].padLeft(2, '0');
          return '$year-$month';
        }
        return paymentMonth;
      } catch (e2) {
        return paymentMonth;
      }
    }
  }

  static String _formatTimeForPdf(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      final hour = date.hour;
      final minute = date.minute.toString().padLeft(2, '0');
      final period = hour >= 12 ? 'PM' : 'AM';
      final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$displayHour:$minute $period';
    } catch (e) {
      return dateTime;
    }
  }

  static PdfColor _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return PdfColors.green;
      case 'ongoing':
        return PdfColors.orange;
      case 'upcoming':
        return PdfColors.blue;
      default:
        return PdfColors.grey;
    }
  }
}
