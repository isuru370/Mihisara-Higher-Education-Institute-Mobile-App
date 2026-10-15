import 'attendance_data_model.dart';

class ScanAttendanceResponseModel {
  final bool success;
  final String message;
  final AttendanceDataModel? data;

  ScanAttendanceResponseModel({
    required this.success,
    required this.message,
    this.data,
  });

  factory ScanAttendanceResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return ScanAttendanceResponseModel(
      success: json['success'] == true,
      message: json['message']?.toString() ?? '',
      data: json['data'] is Map<String, dynamic>
          ? AttendanceDataModel.fromJson(
              json['data'] as Map<String, dynamic>,
            )
          : null,
    );
  }
}