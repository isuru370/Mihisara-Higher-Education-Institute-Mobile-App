import 'dart:io';
import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../data/models/attendance_report/attendance_report_response_model.dart';

class PdfService {
  static Future<void> generateAndSharePdf(
    AttendanceReportResponseModel data,
  ) async {
    try {
      final pdf = await _generatePdf(data);
      final output = await getTemporaryDirectory();
      final filePath = '${output.path}/attendance_report_${DateTime.now().millisecondsSinceEpoch}.pdf';
      final file = File(filePath);
      await file.writeAsBytes(pdf);

      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Attendance Report',
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
        build: (context) {
          return [
            _buildHeader(data),
            _buildScheduleInfo(data),
            _buildSummary(data),
            _buildStudentsList(data),
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
          padding: const pw.EdgeInsets.all(16),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue700,
          ),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                'Attendance Report',
                style: pw.TextStyle(
                  fontSize: 24,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
              pw.SizedBox(height: 8),
              pw.Text(
                data.data.schedule.studentClass.className,
                style: pw.TextStyle(
                  fontSize: 18,
                  color: PdfColors.amber500,
                ),
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
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Schedule Information',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            children: [
              _buildInfoItem('Class', schedule.studentClass.className),
              _buildInfoItem('Category', schedule.classCategoryFee.category.categoryName),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              _buildInfoItem('Date', schedule.classDate.split('T')[0]),
              _buildInfoItem('Time', '${schedule.startTime} - ${schedule.endTime}'),
            ],
          ),
          pw.SizedBox(height: 4),
          pw.Row(
            children: [
              _buildInfoItem('Status', schedule.status.toUpperCase()),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildInfoItem(String label, String value) {
    return pw.Expanded(
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 11,
              color: PdfColors.grey600,
            ),
          ),
          pw.Text(
            value,
            style: pw.TextStyle(
              fontSize: 13,
              fontWeight: pw.FontWeight.bold,
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
      ),
      child: pw.Column(
        children: [
          pw.Text(
            'Summary',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 12),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Total', summary.totalStudents.toString(), PdfColors.blue),
              _buildSummaryItem('Present', summary.presentStudents.toString(), PdfColors.green),
              _buildSummaryItem('Absent', summary.absentStudents.toString(), PdfColors.red),
            ],
          ),
          pw.SizedBox(height: 8),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
            children: [
              _buildSummaryItem('Paid', summary.paidStudents.toString(), PdfColors.blue),
              _buildSummaryItem('Unpaid', summary.unpaidStudents.toString(), PdfColors.orange),
              _buildSummaryItem('Attendance', '${summary.attendancePercentage}%', PdfColors.green),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSummaryItem(String label, String value, PdfColor color) {
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
          style: pw.TextStyle(
            fontSize: 11,
            color: PdfColors.grey600,
          ),
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
          child: pw.Text(
            'Students List (${students.length})',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.SizedBox(height: 8),
        pw.Table(
          border: pw.TableBorder.all(color: PdfColors.grey300),
          children: [
            pw.TableRow(
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
              ),
              children: [
                _buildTableHeader('No'),
                _buildTableHeader('Student Name'),
                _buildTableHeader('Grade'),
                _buildTableHeader('Attendance'),
                _buildTableHeader('Payment'),
              ],
            ),
            ...students.asMap().entries.map((entry) {
              final index = entry.key;
              final student = entry.value;
              final isPresent = student.attendance.isPresent;
              final isPaid = student.payment.isPaid;

              return pw.TableRow(
                children: [
                  _buildTableCell('${index + 1}'),
                  _buildTableCell(student.student.initialName),
                  _buildTableCell('Grade ${student.student.grade}'),
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
            }).toList(),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTableHeader(String text) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 12,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  static pw.Widget _buildTableCell(String text, {PdfColor? color}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 11,
          color: color ?? PdfColors.black,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }
}