class AttendanceSummaryModel {
  final int totalSchedules;
  final int presentCount;
  final int absentCount;
  final int todayCount;
  final int upcomingCount;

  AttendanceSummaryModel({
    required this.totalSchedules,
    required this.presentCount,
    required this.absentCount,
    required this.todayCount,
    required this.upcomingCount,
  });

  factory AttendanceSummaryModel.fromJson(Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      totalSchedules: json['total_schedules'] ?? 0,
      presentCount: json['present_count'] ?? 0,
      absentCount: json['absent_count'] ?? 0,
      todayCount: json['today_count'] ?? 0,
      upcomingCount: json['upcoming_count'] ?? 0,
    );
  }
}