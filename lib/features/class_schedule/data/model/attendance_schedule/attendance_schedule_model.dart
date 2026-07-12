class AttendanceScheduleModel {
  final int scheduleId;
  final String classDate;
  final String day;
  final String startTime;
  final String endTime;
  final String status;

  const AttendanceScheduleModel({
    required this.scheduleId,
    required this.classDate,
    required this.day,
    required this.startTime,
    required this.endTime,
    required this.status,
  });

  factory AttendanceScheduleModel.fromJson(Map<String, dynamic> json) {
    return AttendanceScheduleModel(
      scheduleId: json['schedule_id'],
      classDate: json['class_date'],
      day: json['day'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      status: json['status'],
    );
  }

  bool get isCompleted => status == 'completed';

  bool get isOngoing => status == 'ongoing';
}
