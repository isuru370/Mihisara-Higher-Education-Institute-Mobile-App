class AttendanceModel {
  final String month;

  final int attendedClasses;
  final int totalClasses;
  final int absentClasses;
  final int attendancePercentage;

  AttendanceModel({
    required this.month,
    required this.attendedClasses,
    required this.totalClasses,
    required this.absentClasses,
    required this.attendancePercentage,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic>? json) {
    return AttendanceModel(
      month: json?['month'] as String? ?? '',
      attendedClasses: (json?['attended_classes'] as num?)?.toInt() ?? 0,
      totalClasses: (json?['total_classes'] as num?)?.toInt() ?? 0,
      absentClasses: (json?['absent_classes'] as num?)?.toInt() ?? 0,
      attendancePercentage:
          (json?['attendance_percentage'] as num?)?.toInt() ?? 0,
    );
  }
}
