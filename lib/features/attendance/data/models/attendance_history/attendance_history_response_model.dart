import 'attendance_history_data_model.dart';

class AttendanceHistoryResponseModel {
  final bool success;
  final AttendanceHistoryDataModel data;

  AttendanceHistoryResponseModel({
    required this.success,
    required this.data,
  });

  factory AttendanceHistoryResponseModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryResponseModel(
      success: json['success'] ?? false,
      data: AttendanceHistoryDataModel.fromJson(
        json['data'] as Map<String, dynamic>? ?? {},
      ),
    );
  }
}