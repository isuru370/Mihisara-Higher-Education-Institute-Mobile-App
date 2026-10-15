class TeacherDashboardSummaryModel {
  final int totalClasses;
  final int activeClasses;
  final int ongoingClasses;
  final int totalStudents;
  final int todayClasses;
  final int todayAttendance;
  final int todayExpectedStudents;
  final double attendancePercentage;

  const TeacherDashboardSummaryModel({
    required this.totalClasses,
    required this.activeClasses,
    required this.ongoingClasses,
    required this.totalStudents,
    required this.todayClasses,
    required this.todayAttendance,
    required this.todayExpectedStudents,
    required this.attendancePercentage,
  });

  factory TeacherDashboardSummaryModel.fromJson(
    Map<String, dynamic> json,
  ) {
    return TeacherDashboardSummaryModel(
      totalClasses:
          (json['total_classes'] as num?)?.toInt() ?? 0,

      activeClasses:
          (json['active_classes'] as num?)?.toInt() ?? 0,

      ongoingClasses:
          (json['ongoing_classes'] as num?)?.toInt() ?? 0,

      totalStudents:
          (json['total_students'] as num?)?.toInt() ?? 0,

      todayClasses:
          (json['today_classes'] as num?)?.toInt() ?? 0,

      todayAttendance:
          (json['today_attendance'] as num?)?.toInt() ?? 0,

      todayExpectedStudents:
          (json['today_expected_students'] as num?)?.toInt() ?? 0,

      attendancePercentage:
          (json['attendance_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }
}