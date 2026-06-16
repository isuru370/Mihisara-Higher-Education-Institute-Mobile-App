import 'read_attendance_data_model.dart';

class ReadAttendanceResponseModel {
  final String status;
  final String message;
  final ReadAttendanceDataModel data;

  ReadAttendanceResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory ReadAttendanceResponseModel.fromJson(
    Map<String, dynamic>? json,
  ) {
    return ReadAttendanceResponseModel(
      status:
          json?['status'] as String? ?? '',

      message:
          json?['message'] as String? ?? '',

      data: ReadAttendanceDataModel.fromJson(
        json?['data']
            as Map<String, dynamic>? ??
            {},
      ),
    );
  }
}