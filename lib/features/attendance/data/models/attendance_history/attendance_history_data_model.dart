import 'attendance_history_model.dart';
import 'attendance_summary_model.dart';

class AttendanceHistoryDataModel {
  final int studentId;
  final int enrollmentId;
  final String enrolledAt;
  final int classCategoryFeeId;
  final AttendanceSummaryModel summary;
  final List<AttendanceHistoryModel> history;

  AttendanceHistoryDataModel({
    required this.studentId,
    required this.enrollmentId,
    required this.enrolledAt,
    required this.classCategoryFeeId,
    required this.summary,
    required this.history,
  });

  factory AttendanceHistoryDataModel.fromJson(Map<String, dynamic> json) {
    return AttendanceHistoryDataModel(
      studentId: json['student_id'] ?? 0,
      enrollmentId: json['enrollment_id'] ?? 0,
      enrolledAt: json['enrolled_at'] ?? '',
      classCategoryFeeId: json['class_category_fee_id'] ?? 0,
      summary: AttendanceSummaryModel.fromJson(
        json['summary'] as Map<String, dynamic>? ?? {},
      ),
      history: (json['history'] as List<dynamic>? ?? [])
          .map((e) => AttendanceHistoryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}