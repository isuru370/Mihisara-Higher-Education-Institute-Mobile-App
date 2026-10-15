class AttendanceHistoryModel {
  final int classScheduleId;
  final String classDate;
  final String day;
  final String startTime;
  final String endTime;
  final String scheduleStatus;
  final String attendanceStatus;
  final String? attendedAt;
  final String? markMethod;
  final String? note;

  AttendanceHistoryModel({
    required this.classScheduleId,
    required this.classDate,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.scheduleStatus,
    required this.attendanceStatus,
    required this.attendedAt,
    required this.markMethod,
    required this.note,
  });

  factory AttendanceHistoryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryModel(
      classScheduleId: json['class_schedule_id'] ?? 0,
      classDate: json['class_date'] ?? '',
      day: json['day'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      scheduleStatus: json['schedule_status'] ?? '',
      attendanceStatus: json['attendance_status'] ?? '',
      attendedAt: json['attended_at'],
      markMethod: json['mark_method'],
      note: json['note'],
    );
  }
}