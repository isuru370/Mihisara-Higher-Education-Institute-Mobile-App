class AttendanceReportRequestModel {
  final int scheduleId;

  AttendanceReportRequestModel({
    required this.scheduleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'schedule_id': scheduleId,
    };
  }
}