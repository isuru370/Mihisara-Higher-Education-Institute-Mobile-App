import 'attendance_student_model.dart';
import 'attendance_summary_model.dart';
import 'matched_group_model.dart';

class DailyAttendanceDetailsDataModel {
  final MatchedGroupModel matchedGroup;
  final List<AttendanceStudentModel> attendanceList;
  final AttendanceSummaryModel summary;

  DailyAttendanceDetailsDataModel({
    required this.matchedGroup,
    required this.attendanceList,
    required this.summary,
  });

  factory DailyAttendanceDetailsDataModel.fromJson(Map<String, dynamic> json) {
    return DailyAttendanceDetailsDataModel(
      matchedGroup: MatchedGroupModel.fromJson(json['matched_group']),
      attendanceList: (json['attendance_list'] as List)
          .map((e) => AttendanceStudentModel.fromJson(e))
          .toList(),
      summary: AttendanceSummaryModel.fromJson(json['summary']),
    );
  }
}
