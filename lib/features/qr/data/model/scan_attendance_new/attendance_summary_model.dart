class AttendanceSummaryModel {
  final String month;
  final int totalCount;
  final int presentCount;
  final int absentCount;
  final int attendancePercentage;

  AttendanceSummaryModel({
    required this.month,
    required this.totalCount,
    required this.presentCount,
    required this.absentCount,
    required this.attendancePercentage,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      month: json['month'],
      totalCount: json['total_count'],
      presentCount: json['present_count'],
      absentCount: json['absent_count'],
      attendancePercentage: json['attendance_percentage'],
    );
  }
}