import 'attendance_report_data.dart';

class AttendanceReportResponseModel {
  final bool success;
  final String message;
  final AttendanceReportData data;

  AttendanceReportResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttendanceReportResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceReportResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: AttendanceReportData.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {'success': success, 'message': message, 'data': data.toJson()};
  }
}
