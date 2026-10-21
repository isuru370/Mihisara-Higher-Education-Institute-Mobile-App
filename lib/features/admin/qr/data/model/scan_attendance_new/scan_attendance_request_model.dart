class ScanAttendanceRequestModel {
  final String code;
  final String markMethod;

  /// Sent only after the staff member picks a class from the selection list.
  final int? classScheduleId;

  ScanAttendanceRequestModel({
    required this.code,
    required this.markMethod,
    this.classScheduleId,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'mark_method': markMethod,
      if (classScheduleId != null) 'class_schedule_id': classScheduleId,
    };
  }
}
