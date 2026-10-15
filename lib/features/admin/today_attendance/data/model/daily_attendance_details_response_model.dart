import 'daily_attendance_details_model.dart';

class DailyAttendanceDetailsResponseModel {
  final bool status;
  final DailyAttendanceDetailsDataModel data;

  DailyAttendanceDetailsResponseModel({
    required this.status,
    required this.data,
  });

  factory DailyAttendanceDetailsResponseModel.fromJson(
      Map<String, dynamic> json) {
    return DailyAttendanceDetailsResponseModel(
      status: json['status'],
      data: DailyAttendanceDetailsDataModel.fromJson(json['data']),
    );
  }
}
