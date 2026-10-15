import 'attendance_schedule_model.dart';

class AttendanceScheduleResponseModel {
  final bool success;
  final String message;
  final List<AttendanceScheduleModel> data;

  const AttendanceScheduleResponseModel({
    required this.success,
    required this.message,
    required this.data,
  });

  factory AttendanceScheduleResponseModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return AttendanceScheduleResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: (json['data'] as List<dynamic>)
          .map(
            (e) => AttendanceScheduleModel.fromJson(e),
          )
          .toList(),
    );
  }
}