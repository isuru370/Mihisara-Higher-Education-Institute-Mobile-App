import 'schedule_data.dart';
import 'student_data.dart';
import 'summary_data.dart';

class AttendanceReportData {
  final ScheduleData schedule;
  final SummaryData summary;
  final List<StudentData> students;

  AttendanceReportData({
    required this.schedule,
    required this.summary,
    required this.students,
  });

  factory AttendanceReportData.fromJson(Map<String, dynamic> json) {
    return AttendanceReportData(
      schedule: ScheduleData.fromJson(json['schedule']),
      summary: SummaryData.fromJson(json['summary']),
      students: (json['students'] as List? ?? [])
          .map((e) => StudentData.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'schedule': schedule.toJson(),
      'summary': summary.toJson(),
      'students': students.map((e) => e.toJson()).toList(),
    };
  }
}
