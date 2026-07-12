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

  factory ScanAttendanceResponseModel.fromJson(Map<String, dynamic> json) {
    return ScanAttendanceResponseModel(
      success: json['success'],
      message: json['message'],
      data: json['data'] != null
          ? AttendanceDataModel.fromJson(json['data'])
          : null,
    );
  }
}