class ReadAttendanceModel {
  final String month;
  final int attendedClasses;
  final int totalClasses;
  final int absentClasses;
  final int attendancePercentage;

  ReadAttendanceModel({
    required this.month,
    required this.attendedClasses,
    required this.totalClasses,
    required this.absentClasses,
    required this.attendancePercentage,
  });

  factory ReadAttendanceModel.fromJson(Map<String, dynamic> json) {
    return ReadAttendanceModel(
      month: json['month'] ?? '',
      attendedClasses: json['attended_classes'] ?? 0,
      totalClasses: json['total_classes'] ?? 0,
      absentClasses: json['absent_classes'] ?? 0,
      attendancePercentage: json['attendance_percentage'] ?? 0,
    );
  }
}