class AttendanceSummaryModel {
  final String date;
  final String requestedStatus;
  final int totalStudents;
  final int present;
  final int absent;
  final double attendancePercentage;

  AttendanceSummaryModel({
    required this.date,
    required this.requestedStatus,
    required this.totalStudents,
    required this.present,
    required this.absent,
    required this.attendancePercentage,
  });

  factory AttendanceSummaryModel.fromJson(
      Map<String, dynamic> json) {
    return AttendanceSummaryModel(
      date: json['date'],
      requestedStatus: json['requested_status'],
      totalStudents: json['total_students'],
      present: json['present'],
      absent: json['absent'],
      attendancePercentage:
          (json['attendance_percentage'] as num).toDouble(),
    );
  }
}
