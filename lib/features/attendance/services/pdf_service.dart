import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../data/models/attendance_report/attendance_report_response_model.dart';

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

      await Share.shareXFiles([XFile(filePath)], text: 'Attendance Report');
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
        build: (context) {
          return [
            _buildHeader(data),
            _buildScheduleInfo(data),
            _buildSummary(data),
            _buildStudentsList(data),
            _buildFooter(), // Context එක pass නොකර
          ];
        },
      ),
    );

    return await pdf.save();
  }

  static pw.Widget _buildHeader(AttendanceReportResponseModel data) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.all(20),
          decoration: pw.BoxDecoration(
            gradient: pw.LinearGradient(
              begin: pw.Alignment.topLeft,
              end: pw.Alignment.bottomRight,
              colors: [PdfColors.blue700, PdfColors.blue900],
            ),
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                '📋 Attendance Report',
                style: pw.TextStyle(
                  fontSize: 28,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                data.data.schedule.studentClass.className,
                style: pw.TextStyle(fontSize: 20, color: PdfColors.amber300),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                'Generated: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(fontSize: 12, color: PdfColors.amber700),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 16),
      ],
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
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe8b0), color: PdfColors.blue700),
              pw.SizedBox(width: 8),
              pw.Text(
                'Schedule Information',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ],
          ),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('📚 Class', schedule.studentClass.className),
              _buildInfoItem(
                '📂 Category',
                schedule.classCategoryFee.category.categoryName,
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('📅 Date', schedule.classDate.split('T')[0]),
              _buildInfoItem(
                '⏰ Time',
                '${schedule.startTime} - ${schedule.endTime}',
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem(
                '📊 Status',
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
            style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 14,
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
          pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe2b0), color: PdfColors.blue700),
              pw.SizedBox(width: 8),
              pw.Text(
                '📊 Summary',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ],
          ),
          pw.Divider(color: PdfColors.grey300),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem(
                '👥 Total',
                summary.totalStudents.toString(),
                PdfColors.blue,
              ),
              _buildSummaryItem(
                '✅ Present',
                summary.presentStudents.toString(),
                PdfColors.green,
              ),
              _buildSummaryItem(
                '❌ Absent',
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
                '💳 Paid',
                summary.paidStudents.toString(),
                PdfColors.blue,
              ),
              _buildSummaryItem(
                '💸 Unpaid',
                summary.unpaidStudents.toString(),
                PdfColors.orange,
              ),
              _buildSummaryItem(
                '📈 Attendance',
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
                '💰 Payment',
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
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
            color: color,
          ),
        ),
        pw.Text(
          label,
          style: pw.TextStyle(fontSize: 11, color: PdfColors.grey600),
        ),
      ],
    );
  }

  static pw.Widget _buildStudentsList(AttendanceReportResponseModel data) {
    final students = data.data.students;
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.symmetric(horizontal: 16),
          child: pw.Row(
            children: [
              pw.Icon(pw.IconData(0xe7fd), color: PdfColors.blue700),
              pw.SizedBox(width: 8),
              pw.Text(
                'Students List (${students.length})',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300, width: 0.5),
          children: [
            // Header Row
            pw.TableRow(
              decoration: pw.BoxDecoration(color: PdfColors.blue700),
              children: [
                _buildTableHeader('No', color: PdfColors.white),
                _buildTableHeader('Student ID', color: PdfColors.white),
                _buildTableHeader('Student Name', color: PdfColors.white),
                _buildTableHeader('Grade', color: PdfColors.white),
                _buildTableHeader('Contact', color: PdfColors.white),
                _buildTableHeader('Attendance', color: PdfColors.white),
                _buildTableHeader('Payment', color: PdfColors.white),
              ],
            ),
            // Data Rows
            ...students.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;
              final isPresent = student.attendance.isPresent;
              final isPaid = student.payment.isPaid;
              final rowColor = index % 2 == 0
                  ? PdfColors.grey50
                  : PdfColors.white;

              return pw.TableRow(
                decoration: pw.BoxDecoration(color: rowColor),
                children: [
                  _buildTableCell('${index + 1}'),
                  _buildTableCell(student.student.studentCode),
                  _buildTableCell(student.student.initialName),
                  _buildTableCell('Grade ${student.student.grade}'),
                  _buildTableCell(student.student.guardianMobile),
                  _buildTableCell(
                    isPresent ? '✅ Present' : '❌ Absent',
                    color: isPresent ? PdfColors.green : PdfColors.red,
                  ),
                  _buildTableCell(
                    isPaid ? '💰 Paid' : '💸 Unpaid',
                    color: isPaid ? PdfColors.blue : PdfColors.orange,
                  ),
                ],
              );
            }).toList(),
          ],
        ),
        pw.SizedBox(height: 16),
        // Payment Details Section for Paid Students
        pw.Container(
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
                '💰 Payment Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              ...students.where((s) => s.payment.isPaid).map((student) {
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          student.student.initialName,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          'Rs ${student.payment.amount}',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: PdfColors.green,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          student.payment.receiptNumber ?? 'N/A',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
              if (students.where((s) => s.payment.isPaid).isEmpty)
                pw.Text(
                  'No paid students found',
                  style: pw.TextStyle(fontSize: 12, color: PdfColors.grey600),
                ),
            ],
          ),
        ),
        pw.SizedBox(height: 8),
        // Attendance Details Section
        pw.Container(
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
                '⏰ Attendance Details',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue700,
                ),
              ),
              pw.Divider(color: PdfColors.grey300),
              pw.SizedBox(height: 8),
              ...students.map((student) {
                final isPresent = student.attendance.isPresent;
                final attendedAt = student.attendance.attendedAt;
                return pw.Container(
                  padding: const pw.EdgeInsets.symmetric(vertical: 4),
                  child: pw.Row(
                    children: [
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          student.student.initialName,
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                      pw.Expanded(
                        flex: 1,
                        child: pw.Text(
                          isPresent ? '✅ Present' : '❌ Absent',
                          style: pw.TextStyle(
                            fontSize: 12,
                            fontWeight: pw.FontWeight.bold,
                            color: isPresent ? PdfColors.green : PdfColors.red,
                          ),
                        ),
                      ),
                      pw.Expanded(
                        flex: 2,
                        child: pw.Text(
                          attendedAt != null
                              ? _formatTimeForPdf(attendedAt)
                              : 'N/A',
                          style: const pw.TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
          color: color ?? PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(fontSize: 10, color: color ?? PdfColors.black),
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
                'Generated by Nexorait Education App',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
              pw.Text(
                'Generated on: ${DateTime.now().toString().split(' ')[0]}',
                style: pw.TextStyle(fontSize: 10, color: PdfColors.grey600),
              ),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            'This is a computer-generated report. No signature required.',
            style: pw.TextStyle(
              fontSize: 9,
              color: PdfColors.grey500,
              fontStyle: pw.FontStyle.italic,
            ),
          ),
        ],
      ),
    );
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
